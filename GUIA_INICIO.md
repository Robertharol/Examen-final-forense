# Guía de inicio – Caso M57-Patents

## 1. ¿De qué trata el caso?

M57.biz es una pequeña empresa ficticia de Monterey (California) que investiga patentes.
Tiene 4 empleados, todos con equipos Windows:

| Persona | Cargo | Correo |
|---|---|---|
| Pat McGoo | Presidente / CEO | pat@m57.biz |
| Terry Johnson | Administrador de TI | terry@m57.biz |
| Jo Smith | Investigadora de patentes | jo@m57.biz |
| Charlie Brown | Investigador de patentes | charlie@m57.biz |

El escenario se simuló entre el **13-nov y el 11-dic de 2009**. Las diapositivas plantean **3 casos**
sobre las mismas evidencias:

1. **Illegal** (material digital ilícito). Es el caso que resolvemos primero, en `INFORME_CASO1_ILLEGAL.md`.
2. **Exfiltration**: un empleado roba propiedad intelectual y se la pasa a un tercero.
3. **Eavesdropping**: un empleado espía electrónicamente a Pat.

### Caso 1, el hecho
Aaron Greene compra en **Craigslist** un ordenador usado. Al encenderlo encuentra imágenes y vídeos
"ilícitos" (en el escenario se simulan con **fotos y vídeos de gatos**: *"kitty exploitation"*) y lo
denuncia a la policía. La policía averigua que el equipo era de M57 y que lo usaba **Jo**. Pat autoriza
a la policía a hacer imagen forense de todos los equipos, y se obtiene una orden para incautar el USB
personal de Jo.

### Preguntas (puntos de pericia) del Caso 1
1. ¿Es Jo la responsable (propietaria) de los archivos? ¿Qué evidencias lo confirman o lo descartan?
2. ¿Cómo llegó el equipo al mercado de segunda mano?
3. ¿Quién de la empresa es responsable de la venta (¿robo?) del equipo?
4. ¿Hubo intentos de ocultar estas actividades?
5. ¿Hay otras actividades sospechosas en M57?
6. (Extra) ¿Quiénes son los contactos externos? ¿Hay archivos que vienen del teléfono de Terry?

## 2. ¿Qué hay que descargar?

Todo está en el bucket público de Digital Corpora (la web `digitalcorpora.org` solo enlaza a él):

`https://digitalcorpora.s3.amazonaws.com/corpora/scenarios/2009-m57-patents/`

| Carpeta | Contenido | ¿Necesario? |
|---|---|---|
| `docs/` | Diapositivas, **4 informes del detective**, **orden judicial y affidávit** | Sí (son PDF pequeños) |
| `drives-redacted/` | Imágenes de disco **E01** (una por persona y día) | Sí, ver lista mínima abajo |
| `net/` | Capturas de tráfico **.pcap.gz** por día | Sí, para el perito de RED |
| `ram/` | Volcados de RAM | Opcional |
| `drives_dfxml/` | Listado de archivos de cada imagen en XML | Útil para ir rápido |
| `drives-be1.3/` | Salida de *bulk_extractor* (correos, URL, etc.) | Útil |
| `docs/m57-instructor-packet.pdf`, `docs/scenario-emails.zip` | Solucionario del profesor (**con contraseña**) | No disponible |

### Lista mínima para el Caso 1 (≈ 25 GB)
Perito 1 (discos):
- `drives-redacted/jo-2009-11-20-oldComputer.E01` (4 GB). **Es el ordenador que se vendió.**
- `drives-redacted/terry-2009-12-11-001.E01` (10,6 GB). Equipo del vendedor.
- `drives-redacted/pat-2009-12-11.E01` (6,1 GB). Correos del CEO.
- `drives-redacted/jo-favorites-usb-2009-12-11.E01` (227 MB). USB personal incautado a Jo.
- `drives-redacted/jo-work-usb-2009-12-11.E01` (118 MB)
- `drives-redacted/terry-work-usb-2009-12-11.E01` (33 MB)
- Opcional: `jo-2009-12-11-001.E01` (el equipo nuevo de Jo)

Perito 2 (red):
- `net/net-2009-11-20-10:30.pcap.gz` (cambio del equipo de Jo)
- `net/net-2009-11-23-16:54.pcap.gz` (incluye la publicación en Craigslist del 24-nov)
- `net/net-2009-12-0*.pcap.gz` (anuncios del 7 al 9 de diciembre)

> En Windows, los nombres con `:` no son válidos. Al descargar, renómbralos, por ejemplo `net-2009-11-23-1654.pcap.gz`.
> Cómo descargar: abre la URL del archivo en el navegador, o en PowerShell:
> `Invoke-WebRequest -Uri "https://digitalcorpora.s3.amazonaws.com/corpora/scenarios/2009-m57-patents/drives-redacted/jo-2009-11-20-oldComputer.E01" -OutFile jo-old.E01`

## 3. Cómo empezar en Autopsy (Perito 1)
1. Instala Autopsy (https://github.com/sleuthkit/autopsy/releases).
2. *New Case* → nombre `M57-Caso1` → examinador: tu nombre.
3. *Add Data Source* → *Disk Image or VM file* → selecciona el `.E01`. Zona horaria: **US/Pacific** (importante).
4. Activa los *Ingest Modules*: Recent Activity, Hash Lookup, File Type Identification, EXIF,
   Keyword Search, Email Parser, Interesting Files, **USB Device Attached** (Recent Activity), Extension Mismatch.
5. Añade las demás imágenes al **mismo caso** (una fuente de datos por imagen).
6. Revisa:
   - `Views → File Types → Images/Videos` y la carpeta `Documents and Settings\Jo\Desktop\Pics`.
   - `Results → Extracted Content → USB Device Attached` y `Recent Documents`.
   - `Results → E-Mail Messages` (Outlook Express `.dbx` de Pat y Jo; Windows Mail `.eml` de Terry).
   - `Keyword search`: `craigslist`, `aarongreene12`, `Dell Computer For Sale`, `Equipment Disposal`, `C1111`.
   - `Tools → Timeline` para el 18, 20 y 24 de noviembre.
7. Para cada hallazgo: clic derecho → *Add File Tag* (*Notable Item*) → luego *Generate Report* (HTML).

## 4. Cómo empezar en Wireshark (Perito 2)
1. Abre el `.pcap.gz` (Wireshark lo abre comprimido).
2. *Statistics → Endpoints / Conversations*. Para identificar equipos: filtro `bootp.option.hostname` (en versiones nuevas, `dhcp.option.hostname`).
   Así se asocia cada IP/MAC con M57-TERRY, m57-jo, m57-pat y m57-charlie.
3. Filtros útiles:
   - `http.host contains "craigslist"`
   - `smtp || pop || imap` (los correos internos de m57.biz viajan en claro)
   - `http.request.method == "POST"`
4. *File → Export Objects → HTTP / IMF* para extraer páginas, imágenes y correos.
5. *Follow → TCP Stream* sobre el tráfico de correo para leer los mensajes completos.
