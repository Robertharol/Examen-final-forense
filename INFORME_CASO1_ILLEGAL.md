# INFORME PERICIAL INFORMÁTICO
## Caso M57-Patents. Parte 1: Material digital ilícito ("Illegal")

| Campo | Valor |
|---|---|
| Expediente policial | MT-2009-12-015 (Policía de Monterey, CA) |
| Evidencia principal | MT-2009-12-015-EV001 (ordenador comprado por Aaron Greene) |
| Orden judicial | MT-2009-12-015-W001 (USB personal de Jo) |
| **Perito 1, análisis de imágenes de disco** | `[Nombre del alumno 1]` |
| **Perito 2, análisis de tráfico de red** | `[Nombre del alumno 2]` |
| Fecha del informe | `[fecha]` |

> En cada actividad se indica entre corchetes qué perito la realizó: **[P1]** = discos, **[P2]** = red.
> Todas las horas se dan en **hora del Pacífico (PST = UTC−8)** salvo que se indique UTC.

---

## 1. Antecedentes

1. **09-dic-2009, 11:30.** Aaron Greene (123 Cloudy Hill Dr., Monterey) denuncia que un ordenador comprado
   por **Craigslist** contiene imágenes y vídeos de "explotación de gatitos". Identifica al vendedor como
   **Terry Johnson** (Informe del detective nº 001).
2. **10-dic.** El laboratorio policial determina que el equipo pertenecía a **M57 Patents** y que su usuario era
   **Jo** (Informe 002).
3. **10-dic.** Pat McGoo (CEO) declara que el equipo "probablemente fue robado", pues le habían dicho que **no
   funcionaba** (Informe 003). Se obtiene una orden para incautar un USB de Jo (Informe 004).
4. **11-dic.** Pat autoriza la imagen forense de todos los equipos de M57.

> En el escenario académico el material ilícito se simula con fotos y vídeos de gatos (carpeta oficial
> `KittyMaterial` del corpus: `DSC000xx.JPG`, `Cat.mov`, `Cat.m4v`, `MontereyKitty*.m4v`, `TiggerTheCat.m4v`,
> `KittyMontage.mov`).

## 2. Objeto de la pericia (puntos de pericia)

1. ¿Es Jo responsable de los archivos hallados en el equipo vendido? ¿Qué evidencias lo apoyan o lo descartan?
2. ¿Cómo llegó el equipo al mercado de segunda mano?
3. ¿Quién de la empresa es responsable de la venta del equipo?
4. ¿Se intentó ocultar alguna de estas actividades?
5. ¿Existen otras actividades sospechosas en M57?
6. ¿Quiénes son las personas externas que aparecen? ¿Están implicadas?
7. ¿Hay en el corpus archivos procedentes del teléfono de Terry? ¿Guardan relación con el caso?

## 3. Evidencias analizadas

Fuente: `https://digitalcorpora.s3.amazonaws.com/corpora/scenarios/2009-m57-patents/`

| Id | Archivo | Descripción | MD5 adquisición (ewfinfo) | Perito |
|---|---|---|---|---|
| E1 | `jo-2009-11-20-oldComputer.E01` | **Equipo antiguo de Jo, el vendido a Aaron (EV001)** | ad0b487629e30f9f975ca5eaee81ea75 | P1 |
| E2 | `terry-2009-12-11-001.E01` | Equipo de Terry (Windows Vista) | e21dda28db6ef060c294964dda624265 | P1 |
| E3 | `pat-2009-12-11.E01` | Equipo de Pat (Windows XP) | b30759487bb399387bbad6e776b1ed94 | P1 |
| E4 | `jo-favorites-usb-2009-12-11.E01` | **USB personal de Jo** (incautado con orden), etiqueta `JO FAVORITE` | ad1d03cbdb8d81e918899479360f50dc | P1 |
| E5 | `jo-work-usb-2009-12-11.E01` | USB de trabajo de Jo, etiqueta `UNTITLED 1` | 8f23279deb398c3245829a98bc8fc1bd | P1 |
| E6 | `terry-work-usb-2009-12-11.E01` | USB de trabajo de Terry, etiqueta `TERRYS WORK` | e07f26954b23db1a44dfd28ecd717da9 | P1 |
| E7 | `jo-2009-12-11-001.E01` | Equipo nuevo de Jo (analizado vía DFXML) | n/d | P1 |
| E8 | `net-2009-11-23-16:54.pcap.gz` (+ otros días) | Tráfico de red de la oficina | n/a | P2 |
| D1 | `detectivereport1-4.pdf`, `m57-affidavit-warrant-final.pdf` | Documentación policial | n/a | P1/P2 |

**Herramientas:** Autopsy 4.x / The Sleuth Kit 4.12 (`mmls`, `fls`, `icat`, `ifind`, `fsstat`), libewf (`ewfinfo`),
Wireshark / Python-dpkt, python-registry (lectura de colmenas), bulk_extractor 1.3 (salida incluida en el corpus),
DFXML (listados de archivos del corpus), y los scripts propios de la carpeta `scripts/`.

## 4. Metodología y actividades (paso a paso)

### 4.1 Preservación [P1]
1. Descarga de las imágenes E01 y verificación con `ewfinfo` / *Verify* de Autopsy (hash MD5 almacenado en el E01).
2. Todo el trabajo se hace sobre copias, en modo solo lectura (Autopsy no modifica la imagen).
3. Creación del caso en Autopsy con zona horaria **US/Pacific**.

### 4.2 Identificación del equipo vendido [P1]
1. En el corpus hay dos imágenes del 20-nov: `jo-2009-11-20-oldComputer` y `jo-2009-11-20-newComputer`.
   Ese día se **sustituyó el equipo de Jo**.
2. El correo de Jo a Pat (20-nov 14:29, *"Equipment Disposal"*) lo confirma: *"My computer had to be swapped out today"*.
3. El 10-dic Pat pregunta a Terry: *"is this serial number from that computer Jo used to have? C1111"* y Terry
   responde *"You are correct"*. **El equipo EV001 es el Dell nº de serie C1111, el antiguo equipo de Jo (E1).**

### 4.3 Localización del material ilícito [P1]
Comparación por nombre y tamaño exacto con el conjunto de referencia `KittyMaterial` (Autopsy: *File Search by
Attributes* / *Hash Lookup*; en línea de comandos, `fls -r -p` + script `scripts/dfx.py`).

| Ubicación | Hallazgo | Estado |
|---|---|---|
| E1 `C:\Documents and Settings\Jo\Desktop\Pics\` | 40+ JPG `DSC000xx` y carpeta `HighQuality\` | Asignados (copiados el **18-nov 10:11**) |
| E1 `...\Jo\Desktop\Pics\NEW\` | `Cat.mov`, `Cat.m4v`, `DSC00009-27.JPG` | Asignados (copiados el **20-nov 09:38**) |
| E4 USB personal `JO FAVORITE` | `DSC000xx.JPG` y `HighQuality\` (94 coincidencias) | **Asignados, no borrados** |
| E5 USB trabajo de Jo | `Cat.mov`, `Cat.m4v`, `MontereyKittyHQ.m4v`, `TiggerTheCat copy.m4v`, `_SC000xx.JPG` (53) | **Todos borrados** |
| E7 equipo nuevo de Jo | `$OrphanFiles\Videos\Cat.mov`, `Cat.m4v`, `KittyMontage.mov`, `MontereyKitty*.m4v` + ficheros `._*` | **Borrados** (16) |
| E6 USB de Terry / USB de Charlie | Ninguna coincidencia | n/a |

Listados completos: `evidencias/jo_oldComputer_material_ilicito.tsv`, `evidencias/jo-favorites-usb_material_ilicito.tsv`, `evidencias/jo-work-usb_material_ilicito.tsv`.

### 4.4 Atribución del uso. Registro de Windows del equipo E1 [P1]
Extracción con `icat` (o Autopsy → *Recent Activity*) de `SYSTEM` y `Documents and Settings\Jo\NTUSER.DAT`.

**a) Dispositivos USB conectados (`SYSTEM\ControlSet\Enum\USBSTOR`)**

| Dispositivo (nº serie) | Última escritura (UTC) | Hora PST | Correlación |
|---|---|---|---|
| USB 2.0 Flash Disk (51491E64) | 17-nov 18:45 | 17-nov 10:45 | Montado como **E: "TERRYS WORK"**: Terry trabajando en el equipo |
| LaCie Rugged FW/USB | 17-nov 00:20 | 16-nov 16:20 | Disco externo conectado antes del inicio de la actividad |
| **Generic Flash Disk (2B9ECCFF)** | 18-nov 18:10 | **18-nov 10:10** | **1 minuto después** se crea `Desktop\Pics` con las fotos (10:11) |
| **Imation USB Flash Drive (AADA04411400000B)** | 20-nov 17:37 | **20-nov 09:37** | **1 minuto después** se crea `Pics\NEW` con los vídeos (09:38) |

**b) Documentos recientes del perfil de Jo (`NTUSER.DAT\...\Explorer\RecentDocs`)**
`DSC00003.JPG`, `DSC00008.JPG`, `DSC00009.JPG`, `Cat.mov`, `Cat.m4v`, `Tigger.m4v`, `TiggerTheCat.m4v`,
`TiggerTheCat (copy).m4v`, y las carpetas `Pics`, `NEW`, `HighQuality`. Los mismos documentos recientes contienen
también archivos de trabajo de Jo (`Definitions.odt`, `patentauto.py`, `urls.txt`). **Los archivos se abrieron
desde la sesión de usuario de Jo** y se visualizaron (último acceso 20-nov entre 09:50 y 09:52).

**c) Origen de los soportes**
Los USB E4 y E5 están formateados en un **Mac** (OEM `BSD 4.4`, carpetas `.Spotlight-V100`, `.Trashes`,
`.fseventsd`, índice `tmp.SnowLeopard`, ficheros AppleDouble `._Cat.mov`). Todos los equipos de M57 son
Windows, así que el material se preparó en un **equipo personal ajeno a la empresa**.
Comparando el mismo archivo en NTFS (UTC) y en el USB FAT (hora local del Mac) se observa un desfase constante
de −3 h. Las marcas de tiempo FAT deben corregirse con ese desfase antes de integrarlas en la línea de tiempo.

### 4.5 Correo electrónico [P1]
- **Pat (E3):** Outlook Express. Extracción de `Inbox.dbx`, `Sent Items.dbx`, `Deleted Items.dbx` y de la carpeta
  **`Computers.dbx`**, que Pat creó para agrupar los correos sobre equipos (Autopsy → *Email Parser*; aquí se usó
  `scripts/dbx.py`).
- **Jo (E1):** Outlook Express `Inbox.dbx` / `Sent Items.dbx`.
- **Terry (E2):** Windows Mail (`Users\terry\AppData\Local\Microsoft\Windows Mail\Local Folders\*.eml`).
  Terry usa además la cuenta personal **t93940@gmail.com**, que descarga en el mismo cliente.

Correos clave (texto íntegro en `evidencias/correos_pat_clave.txt` y `evidencias/correos_terry_clave.txt`):

| Fecha (PST) | De → Para | Asunto | Contenido relevante |
|---|---|---|---|
| 18-nov 10:27 | Jo → Terry | computer problem | "It's gotten really slow all of a sudden" |
| 18-nov 09:43 | Terry → Pat | Need Larger Hard Drive | Pide comprar un disco y que se lo reembolsen |
| 19-nov 11:28 | t93940@gmail → terry@m57 | ABC Tech Receipt | **"Send receipt on to Pat.... :)"**. Adjunto: recibo de **$100** |
| 19-nov 12:58 | Terry → Pat | Hard Drive Receipt | Adjunto: el mismo recibo, **modificado a $300** |
| 19-nov 13:01 | Terry → Cod Williams | Re: How's It Going? | "I really shouldn't gamble anymore, but **I just made a quick $200**" |
| 20-nov 09:56 | Terry → Jo | Re: computer problem | "I'm coming over ... with a new computer to swap out for your **broken down** computer" |
| 20-nov 14:29 | Jo → Pat | Equipment Disposal | Pide que se elimine bien: "There could be company information on there" |
| 20-nov 14:40 | Pat → Terry (gmail), Jo | Re: Equipment Disposal | "Terry - what did you /are you going to/ do with Jo's computer? **We need to make sure it is properly erased!**" |
| 20-nov 14:43 | **Terry (t93940@gmail)** → Pat | Re: Equipment Disposal | **"Don't worry - I'll take care of everything."** |
| 24-nov 13:27 | Craigslist → t93940@gmail | Your craigslist posting **'Dell Computer For Sale'** | Anuncio ID 1480908596 |
| 30-nov 09:45 | **Aaron Greene** (aarongreene12@gmail.com) → Terry | Dell Computer For Sale - **$1000** | "Is the computer still available?" |
| 30-nov 10:00 | Terry → Aaron | Re: Dell Computer... | "still available. I'll give you a call ... with **directions to my place**" |
| 07/08/09-dic | Craigslist → Terry | 'Dell 17" Monitor', 'Sony Playstation 3', 'HP Printer' | Nuevos anuncios |
| 09-dic 09:51 | Terry → Pat | Re: Computer Equipment | Pide comprar **monitores**, portátiles, etc. |
| 10-dic 13:07 | Terry → Jean Sizemore | Re: HP Printer & Dell Monitor | Le vende **monitor + impresora por $200** |
| 10-dic 13:08 | Terry → Cod Williams | Re: Poker Tournament | "I am really struggling ... I will be able to get cash tonight" |
| 10-dic 14:11 | Pat → Terry | Computer Serial Number | "is this serial number from that computer Jo used to have? **C1111**" → Terry: "You are correct" |
| 10-dic 14:53 | Terry → Pat | Re: Computer Serial Number | Envía `M57Inventory.xls`, donde **C1111 figura como "N/A"** (sin asignar, como si siguiera en stock) |

### 4.6 Ocultación (anti-forense) [P1]
- Terry movió a **"Deleted Items"** los correos de confirmación de Craigslist (*Dell Computer*, *Dell 17" Monitor*,
  *Sony Playstation 3*). Según el DFXML, la carpeta se modificó el **09-dic 14:04 PST**, el mismo día en que Pat
  empezó a preguntar por el inventario. Siguen siendo recuperables.
- Terry separa sus asuntos personales en la cuenta gmail: "please send email to my gmail account. I'd like to keep
  my personal life and work life separate".
- Terry **no borró** el disco, pese a la orden expresa de Pat, y lo vendió con los datos dentro.
- Jo **borró** las 53 copias del USB de trabajo (E5) y los vídeos del equipo nuevo (E7), pero conservó las fotos en
  su USB personal (E4).

### 4.7 Análisis de tráfico de red [P2]
1. Apertura de `net-2009-11-23-16:54.pcap.gz` en Wireshark.
2. Identificación de equipos por DHCP (filtro `bootp.option.hostname`):

   | MAC | Hostname DHCP | IP |
   |---|---|---|
   | 00:08:74:38:01:b4 | **M57-TERRY** | **192.168.1.105** (User-Agent *Windows NT 6.0* = Vista) |
   | 00:0b:db:63:5e:a7 | m57-jo | dinámica |
   | 00:0b:db:63:5b:d4 | m57-pat | dinámica |
   | 00:0b:db:4f:6b:10 | m57-charlie | dinámica |

3. Filtro `http.host contains "craigslist"`: **solo 192.168.1.105 (M57-TERRY)** accede a Craigslist.
   - 24-nov 13:11:43 PST: `GET http://craigslist.org/` → `geo.craigslist.org/iso/us/ca` → `monterey.craigslist.org`.
   - 24-nov 13:24 PST: descarga de la imagen del anuncio (`images.craigslist.org/...jpg`).
   - 13:27 PST: llega la confirmación del anuncio *'Dell Computer For Sale'* a t93940@gmail.com (correlación con E2).
   **La publicación del anuncio se hizo desde el equipo de Terry, dentro de la oficina y en horario laboral.**
4. El correo interno de m57.biz viaja **en claro** (filtro `imf` / `pop || imap || smtp`). Se pueden reconstruir
   los mensajes con *File → Export Objects → IMF* y contrastarlos con los extraídos de los discos.
5. *Pendiente / ampliación para P2:* revisar `net-2009-11-20-10:30.pcap.gz` (día del cambio de equipo) y las capturas
   del 7 al 9 de diciembre (anuncios del monitor, la PS3 y la impresora), con los mismos filtros.

### 4.8 Archivos del teléfono de Terry [P1]
Los correos *"Multimedia message"* enviados desde **8312332883@mms.att.net** (el número **831-233-2883** aparece en la
firma de Terry) a T93940@gmail.com contienen fotos con EXIF **Make = Motorola**:

| Fecha | Contenido de la foto | Relación |
|---|---|---|
| 23-nov | Maletín de piel (reenviado a Cod Williams: "are those buckles real gold?") | Gasto tras el dinero obtenido |
| **24-nov 11:05** | **Torre Dell en la oficina** | Foto del anuncio *Dell Computer For Sale* (publicado ese mismo día a las 13:27) |
| 07-dic | **Monitor Dell** | Anuncio *Dell 17" Monitor* |
| 08-dic | **PlayStation 3** | Anuncio *Sony Playstation 3* |
| 09-dic | **Impresora HP** | Anuncio *HP Printer* |

Las fotos están hechas **dentro de la oficina de M57** (moqueta y mamparas). Ver `evidencias/terry_adjuntos/fotos_telefono_terry.png`.

## 5. Línea de tiempo consolidada (PST)

| Fecha y hora | Hecho | Fuente | Perito |
|---|---|---|---|
| 16-nov 13:12 | Terry a un amigo: empieza a trabajar para "salir del agujero" (deudas) | E2 correo | P1 |
| 17-nov 10:45 | USB "TERRYS WORK" conectado al equipo de Jo (mantenimiento) | E1 USBSTOR | P1 |
| 17-nov ~16:45 | El USB "JO FAVORITE" se formatea en un Mac | E4 FAT | P1 |
| 18-nov 10:10–10:11 | USB Generic conectado al equipo de Jo; se crean `Desktop\Pics` (fotos de gatos) | E1 | P1 |
| 18-nov 10:27 | Jo: "my computer is really slow" | E1/E2 correo | P1 |
| 19-nov 11:28–12:58 | Terry falsifica el recibo del disco ($100 → $300) y lo envía a Pat | E2/E3 | P1 |
| 19-nov 13:01 | Terry: "I just made a quick $200" | E2 | P1 |
| 20-nov 09:37–09:52 | USB Imation conectado; se crea `Pics\NEW` con vídeos; Jo los abre | E1 | P1 |
| 20-nov 09:56 | Terry anuncia el cambio del equipo "broken down" de Jo | E2 | P1 |
| 20-nov 14:29–14:43 | Jo pide su eliminación segura; Pat ordena borrarlo; Terry: "I'll take care of everything" | E3 | P1 |
| 24-nov 11:05 | Foto de la torre Dell con el móvil de Terry | E2 (MMS) | P1 |
| 24-nov 13:11–13:27 | M57-TERRY navega a Craigslist; se publica "Dell Computer For Sale" | E8 + E2 | P2 + P1 |
| 30-nov 09:45–10:04 | Aaron Greene se interesa; Terry le da cita en **su casa** | E2 | P1 |
| 07–09-dic | Anuncios del monitor, la PS3 y la impresora | E2 | P1 |
| 09-dic 11:30 | Aaron Greene denuncia a la policía | D1 | — |
| 09-dic 14:04 | Terry mueve los correos de Craigslist a "Deleted Items" | E2 | P1 |
| 10-dic 13:07 | Terry vende monitor + impresora a Jean Sizemore por $200 | E2 | P1 |
| 10-dic 14:11–14:53 | Pat identifica el nº C1111; Terry envía un inventario que lo oculta | E2/E3 | P1 |
| 11-dic 08:55 | Pat convoca reunión: llega la policía | E3 | P1 |

## 6. Hipótesis (iter criminis)

**H1, posesión del material (Jo).** Jo trajo de casa, en USB preparados en un Mac personal, fotos y vídeos ilícitos.
Los copió a su escritorio el 18 y el 20 de noviembre y los visualizó con su usuario. Después los borró del USB de
trabajo y del equipo nuevo, pero los conservó en su USB personal.

**H2, apropiación indebida y venta (Terry).** Terry, con deudas de juego, aprovechó el cambio del equipo "lento" de
Jo para declararlo averiado. En lugar de borrarlo, como ordenó Pat, lo fotografió en la oficina, lo anunció en
Craigslist desde el equipo de la empresa y se lo vendió por $1000 a Aaron Greene en su propia casa. Repitió el
patrón con un monitor y una impresora de la empresa (y una PS3). Ocultó el rastro borrando los correos y enviando
a Pat un inventario manipulado. Además falsificó un recibo para cobrar $200 de más.

**Hipótesis alternativas descartadas:**
- *Terry u otra persona colocó el material en el equipo de Jo.* Se descarta porque los archivos están en el **USB personal
  de Jo** (incautado con orden), se copiaron en horario en que Jo estaba trabajando (envió correos a las 10:27 del 18-nov
  y a las 09:55 del 20-nov) y figuran en los documentos recientes del perfil de Jo. El USB de Terry no contiene ese material.
- *El equipo se robó desde fuera.* Se descarta porque el anuncio se publicó desde M57-TERRY, el vendedor fue Terry y la
  foto del anuncio se hizo con su móvil.

## 7. Conclusiones (respuesta a los puntos de pericia)

1. **¿Es Jo responsable de los archivos?** **Sí.** Los archivos del equipo vendido (`Desktop\Pics` y `Pics\NEW`) se
   copiaron desde dispositivos USB a la cuenta de Jo, en su horario de trabajo, y se abrieron desde su perfil
   (RecentDocs). El mismo material está en el **USB personal "JO FAVORITE"**, preparado en un Mac ajeno a la empresa.
   Jo los borró del USB de trabajo y del equipo nuevo, lo que indica conocimiento de su carácter ilícito.
2. **¿Cómo llegó el equipo al mercado de segunda mano?** Tras quejarse Jo de lentitud, Terry sustituyó el equipo
   (20-nov) declarándolo averiado. Pese a la orden de Pat de borrarlo, Terry lo **publicó en Craigslist el 24-nov**
   ("Dell Computer For Sale – $1000") y lo **vendió a Aaron Greene** hacia el 30-nov, sin borrar el disco.
3. **¿Quién es responsable de la venta?** **Terry Johnson**, administrador de TI. Las pruebas son el anuncio, la
   negociación con Aaron, el tráfico de red desde M57-TERRY, la foto hecha con su móvil y el nº de serie C1111.
   Es una apropiación indebida de un bien de la empresa. **Pat no participó** (le dijeron que el equipo no funcionaba)
   y **Jo tampoco** (pidió que se borrase).
4. **¿Hubo intentos de ocultación?** Sí, por ambas partes:
   - Terry: correos de Craigslist movidos a "Deleted Items" (09-dic), cuenta gmail separada, inventario con C1111
     como "N/A", el equipo presentado como "broken down".
   - Jo: borrado de las 53 copias del USB de trabajo y de los vídeos del equipo nuevo.
5. **Otras actividades sospechosas:**
   - **Fraude en gastos:** recibo de ABC Tech falsificado ($100 → $300; "made a quick $200").
   - **Venta de más material de M57:** monitor Dell y impresora HP vendidos a Jean Sizemore ($200), justo cuando
     Terry pedía a Pat comprar monitores nuevos.
   - **Móvil:** ludopatía y deudas (poker, "the hole I created for myself").
   - *Indicios para las partes 2 y 3:* Jo envía "Docs" a Charlie (20-nov), Charlie y Jo hablan de que Pat es "weird",
     Pat se queja de que su equipo va lento y Terry "sabe cuál es el problema" (03-dic).
6. **Personas externas:**
   - **Aaron Greene** (aarongreene12@gmail.com, 831-555-5432): comprador de buena fe y denunciante. No implicado.
   - **Jean Sizemore** (jeansizemore3@gmail.com): compradora del monitor y la impresora. No implicada, de buena fe.
   - **Cod Williams** (ghost.wisp@live.com) y **Jesse Stroud** (tech.norat@hotmail.com): amigos de Terry (poker y
     bebidas). Revelan el móvil económico. No hay pruebas de complicidad.
   - **Jordan Stanford** (js9999sj@yahoo.com): amigo de Jo. Sin implicación.
   - Alex Monroe (nitroba), Kris Harder y Jessie Lissip: contactos profesionales o personales de Pat. Sin relación.
7. **Archivos del teléfono de Terry:** sí. Son las 5 fotos MMS (Motorola, desde el 831-233-2883) del maletín, la torre
   Dell, el monitor, la PS3 y la impresora, tomadas en la oficina. **Están directamente relacionadas**: son las fotos
   de los artículos que Terry vendía en Craigslist.

**Calificación orientativa:** Jo, posesión de material ilícito. Terry, apropiación indebida o hurto de bienes de la
empresa (equipo, monitor, impresora), falsedad documental y fraude (recibo), y negligencia en la protección de
datos de la empresa.

## 8. Anexos
- `evidencias/correos_pat_clave.txt`: correos extraídos del Outlook Express de Pat.
- `evidencias/correos_terry_clave.txt`: correos extraídos del Windows Mail de Terry.
- `evidencias/terry_adjuntos/`: recibo original y falsificado, inventario, fotos del móvil (`md5_adjuntos.txt`).
- `evidencias/*_material_ilicito.tsv`: listados de archivos con ruta, tamaño y marcas de tiempo.
- `scripts/dfx.py` (DFXML → TSV) y `scripts/dbx.py` (extractor de Outlook Express .dbx).
