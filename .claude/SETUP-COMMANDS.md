# Comandos slash personalizados

Estos comandos están en `.claude/commands/` y Claude Code los carga automáticamente al abrir el proyecto.

## Instalar en un ordenador nuevo

```bash
# 1. Clonar el repo (ya incluye .claude/commands/)
git clone <repo-url>
cd outbound-whatsapp

# 2. Claude Code los detecta solo — no hay nada más que hacer
# Verificar que aparecen en la lista de skills al escribir /
```

## Comandos disponibles

### `/cerrar`
Actualiza `CLAUDE.md` con resumen de la sesión: qué hicimos, qué falta, decisiones técnicas.

### `/recall`
Reconstruye el contexto de la última sesión leyendo los archivos `.jsonl` de transcripción en `~/.claude/projects/<project-hash>/`.

Útil al empezar una sesión nueva sin `--resume` o cuando la memoria está vacía.

**Requisito**: los `.jsonl` están en local (`~/.claude/projects/`), no en el repo. El comando funciona en cualquier máquina donde hayas tenido sesiones previas de este proyecto.

## Añadir un comando nuevo

1. Crear `<nombre>.md` en `.claude/commands/`
2. El contenido es la instrucción que ejecuta Claude al invocar `/<nombre>`
3. Commitear → disponible en todos los ordenadores al hacer `git pull`
