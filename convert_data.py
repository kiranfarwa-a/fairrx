import csv, json, re, sys, collections

SRC, OUT = sys.argv[1], sys.argv[2]
FORMS = ['tablet','capsule','syrup','suspension','injection','drops','cream','ointment',
         'gel','sachet','lotion','infusion','inhaler','spray','solution','powder','tab','cap']
SOLID = {'Tablet','Capsule'}
UNITS = r'(mg|mcg|µg|g|iu|ml|%)'

def fix(s):
    s = s.replace('â€¦', ' ').replace('â€“', '-').replace('â', ' ')
    s = re.sub(r'[€¦…]+', ' ', s)
    s = re.sub(r'\.{2,}', ' ', s)
    return re.sub(r'\s+', ' ', s).strip()

def money(s):
    m = re.search(r'([\d,]+(?:\.\d+)?)', s)
    return float(m.group(1).replace(',', '')) if m else None

def pack_count(p):
    p = p.lower()
    if re.search(r'ml|gm|\bg\b|vial|amp', p) and not re.search(r"x", p):
        return None
    m = re.match(r"\s*(\d+)\s*x\s*(\d+)", p)
    if m: return int(m.group(1)) * int(m.group(2))
    m = re.match(r"\s*(\d+)", p)
    return int(m.group(1)) if m else None

def form_of(brand):
    b = brand.lower()
    for f in FORMS:
        if re.search(r'\b' + f + r's?\b', b):
            return {'tab':'Tablet','cap':'Capsule'}.get(f, f.capitalize())
    return 'Other'

def clean_formulation(f):
    f = fix(f)
    f = re.sub(r'(?i)^each[^:]*contains:?-?', '', f)
    f = re.sub(r'(?i)\((as|eq|equivalent|usp|bp)[^)]*\)', ' ', f)
    f = re.sub(r'(?i)(usp|bp) specifications?', ' ', f)
    f = re.sub(r'(?i)\beq\.? ?to\b', ' ', f)
    f = re.sub(r'(?i)\bin an? .*?base\b', ' ', f)
    f = re.sub(r'(\d(?:\.\d+)?\s*(?:mg|mcg|g|ml|iu)?)\s+(?=[A-Z][a-z]{3,})', r'\1; ', f)
    return re.sub(r'\s+', ' ', f).strip(' .;:,-')

def parse(f):
    f = clean_formulation(f)
    # "A + B (650mg + 50mg)" style
    m = re.match(r'^(.*?)\s*\(\s*([\d\.]+\s*\w+(?:\s*[+/]\s*[\d\.]+\s*\w+)+)\s*\)\s*$', f)
    if m:
        names = [n.strip() for n in re.split(r'\s*\+\s*', m.group(1)) if n.strip()]
        amts = [a.strip() for a in re.split(r'\s*[+/]\s*', m.group(2))]
        if len(names) == len(amts):
            return names, amts
    parts = [p.strip() for p in re.split(r'[;,+]| and ', f) if p.strip()]
    names, amts = [], []
    for p in parts:
        m = re.match(r'^([A-Za-z][A-Za-z \-]*?)\s*[:\-]?\s*(\d+(?:\.\d+)?\s*' + UNITS + r'(?:/\s*\d*\s*ml)?)', p, re.I)
        if m:
            names.append(m.group(1).strip()); amts.append(re.sub(r'\s+', '', m.group(2)).lower())
        elif re.match(r'^[A-Za-z][A-Za-z \-]*$', p):
            names.append(p); amts.append('')
    return names, amts

def title(s):
    s = re.sub(r'(?i)\b(as|dihydrate|monohydrate|trihydrate|anhydrous|sodium|potassium|besylate|mesylate|maleate)\b.*$', '', s).strip() if re.match(r'(?i)^\S+\s+(as|dihydrate|monohydrate|trihydrate|anhydrous)\b', s) else s
    s = re.sub(r'(?i)amoxycillin', 'amoxicillin', s)
    s = re.sub(r'(?i)(hydrochloride|hcl)$', '', s.strip()).strip()
    return ' '.join(w.capitalize() for w in s.split())

def core_brand(brand):
    b = fix(brand)
    out = []
    for w in b.split():
        wl = w.lower().strip(',')
        if re.fullmatch(r'\d+(\.\d+)?(mg|mcg|g|ml|iu|%)?(/\d*ml)?', wl): continue
        if re.sub(r's$', '', wl) in FORMS or wl in ('i.v','iv','im','ds','plus','forte'): 
            if wl in ('ds','plus','forte'): out.append(w)
            continue
        out.append(w)
    return ' '.join(out).strip('-, ') or b

rows = list(csv.DictReader(open(SRC, encoding='utf-8-sig')))
seen, meds, skipped = set(), [], 0
for r in rows:
    brand = fix(r['Brand Name']); key = (r['reg_no'], brand.lower())
    if key in seen: continue
    seen.add(key)
    mrp = money(r['MRP']);
    names, amts = parse(r['Formulation'])
    form = form_of(brand)
    if mrp is None or not names or any(len(n) > 40 for n in names) or len(names) > 4:
        skipped += 1; continue
    cnt = pack_count(r['Pack Size'])
    if form in SOLID and cnt:
        price, unit = round(mrp / cnt, 2), 'per ' + form.lower()
    else:
        price, unit = mrp, 'per pack (' + fix(r['Pack Size']) + ')'
    generic = ' + '.join(title(n) for n in names)
    strength = ' + '.join(a for a in amts if a) or ''
    if not strength:
        m = re.search(r'(\d+(?:\.\d+)?\s*(?:mg|mcg|g|ml|iu))', brand, re.I)
        strength = m.group(1).replace(' ', '').lower() if m else ''
    cmp_ok = bool(strength) and len([a for a in amts if a]) == len(names)
    meds.append({'id': 'r%s_%d' % (r['reg_no'], len(meds)), 'brand': brand, 'core': core_brand(brand),
                 'company': fix(r['Company Name']), 'generic': generic, 'strength': strength,
                 'form': form, 'pack': fix(r['Pack Size']), 'price': price, 'unit': unit, 'cmp': cmp_ok})
json.dump(meds, open(OUT, 'w'), ensure_ascii=False, indent=1)
print('rows', len(rows), 'kept', len(meds), 'skipped', skipped)
g = collections.Counter((m['generic'].lower(), m['strength'], m['form']) for m in meds)
print('comparable:', sum(1 for m in meds if m['cmp']));print('groups with 2+ options:', sum(1 for v in g.values() if v > 1))

