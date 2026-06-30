# CLAUDE.md

## Qué estamos haciendo
Sistema outbound WhatsApp con encuestas. WFs n8n generados, sync Mailjet→PG operativo, board Monday en proceso.

## Próximos pasos
- Importar `monday-comunicaciones-wa.xlsx` y extraer IDs de columna → actualizar WF-01
- Registrar webhook WF-02 en Meta Business
- Prueba end-to-end WF-01 con 1-2 contactos reales

## Decisiones tomadas
- Sesiones Claude viven en `.claude-sessions/` (symlink `~/.claude/projects/C--proyectos-outbound-whatsapp`) → viajan con git
- `/recall` lee `.jsonl` locales para reconstruir contexto al inicio de sesión
- `/cerrar` escribe este archivo como resumen cross-máquina
- `contactos` en schema `contactos.contactos` (no `public`)
- Sync Mailjet: ejecución manual = full sync por defecto (delta no detecta cambios manuales de propiedades)
