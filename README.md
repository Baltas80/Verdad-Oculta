# Verdad Oculta

Plataforma multiplataforma de revelación segura de información para Verdad Oculta.

**Principio:** Revelar la verdad. Proteger a quien la revela.

## Plataformas
- Android
- iOS / iPadOS
- Web
- Windows
- macOS
- Linux

## Arquitectura
La interfaz multiplataforma se separará de los componentes de seguridad y del backend. La criptografía no se implementará de forma propia: se utilizarán primitivas y bibliotecas auditadas y mantenidas, con revisión de seguridad antes de producción.

## Diseño
El diseño visual aprobado está bloqueado. No introducir cambios de identidad, paleta o composición sin una decisión explícita del proyecto.

## Seguridad
- Minimización de metadatos
- Cifrado de extremo a extremo cuando corresponda
- Protección de claves mediante APIs seguras de cada plataforma
- TLS
- Almacenamiento cifrado
- Sin publicidad, trackers ni analytics
- Logs sin contenido sensible
- Separación de funciones y privilegios
- Auditoría y pruebas de penetración antes de producción

> Este repositorio está en fase inicial. Ninguna propiedad de anonimato absoluto se da por garantizada; la seguridad se validará técnicamente y mediante auditoría independiente.
