import sys, xml.etree.ElementTree as ET
def strip(t): return t.split('}')[-1]
for ev,el in ET.iterparse(sys.argv[1]):
    if strip(el.tag)=='fileobject':
        d={strip(c.tag):(c.text or '') for c in el}
        for c in el:
            if strip(c.tag)=='hashdigest': d['md5' if c.get('type','').lower()=='md5' else c.get('type')]=c.text
        print('\t'.join([d.get('filename',''),d.get('filesize',''),d.get('alloc',d.get('unalloc','')),d.get('crtime',''),d.get('mtime',''),d.get('atime',''),d.get('md5','')]))
        el.clear()
