# Minimal Outlook Express .dbx message extractor (follows 512-byte message block chains)
import sys,struct
d=open(sys.argv[1],'rb').read()
blocks={}
for off in range(0,len(d)-16,4):
    s,bs,ln,nxt=struct.unpack_from('<IIII',d,off)
    if s==off and bs==0x200 and 0<(ln&0xffff)<=0x200 and (nxt==0 or nxt<len(d)):
        blocks[off]=((ln&0xffff),nxt)
nexts={v[1] for v in blocks.values()}
msgs=[]
for off in blocks:
    if off in nexts: continue
    out=b'';cur=off;seen=set()
    while cur and cur in blocks and cur not in seen:
        seen.add(cur);ln,nx=blocks[cur];out+=d[cur+16:cur+16+ln];cur=nx
    if b'Subject:' in out[:4000] or b'From:' in out[:4000]: msgs.append(out)
for m in msgs:
    print('='*70);print(m.decode('latin1'))
