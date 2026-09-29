from pathlib import Path
from pypdf import PdfReader

for p in sorted(Path('.').glob('*.pdf')):
    print(f'FILE: {p.name}')
    reader = PdfReader(str(p))
    text = ''
    for i, page in enumerate(reader.pages[:25], 1):
        t = page.extract_text() or ''
        text += f'\n--- PAGE {i} ---\n{t}'
    print(text[:40000])
    print('\n' + '='*80 + '\n')
