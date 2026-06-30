# Symlinks de sesiones Claude

Claude guarda las transcripciones de sesión en `~/.claude/projects/<hash>/`.
El hash se genera a partir de la ruta del proyecto: `C:\proyectos\foo` → `C--proyectos-foo`.

Con un symlink, los `.jsonl` viven dentro del repo → viajan con `git push/pull` → `/recall` funciona en cualquier máquina.

## Patrón

| Ruta proyecto | Hash Claude | Symlink |
|---|---|---|
| `C:\proyectos\outbound-whatsapp` | `C--proyectos-outbound-whatsapp` | ✅ |
| `C:\proyectos\inbound-whatsapp` | `C--proyectos-inbound-whatsapp` | ✅ |
| `C:\proyectos\app-redes-sociales` | `C--proyectos-app-redes-sociales` | ✅ |
| `C:\proyectos\outbound-autohero` | `C--proyectos-outbound-autohero` | ✅ |

## Crear symlink para proyecto nuevo

```powershell
# 1. Dentro del repo del proyecto, crear la carpeta de sesiones
New-Item -ItemType Directory -Path "C:\proyectos\<nombre>\.claude-sessions" -Force

# 2. Añadir al .gitignore del proyecto (los jsonl son grandes)
# Opcional: si quieres que viajen con git, NO lo ignores

# 3. Crear el symlink (requiere PowerShell como Administrador)
$proyecto = "<nombre>"  # ej: "nuevo-proyecto"
$target   = "C:\proyectos\$proyecto\.claude-sessions"
$link     = "C:\Users\alvaro\.claude\projects\C--proyectos-$proyecto"

# Borrar si ya existe (Claude lo crea vacío la primera vez)
Remove-Item $link -Recurse -Force -ErrorAction SilentlyContinue

New-Item -ItemType SymbolicLink -Path $link -Target $target
```

## Verificar

```powershell
Get-ChildItem "C:\Users\alvaro\.claude\projects\" | Where-Object { $_.LinkType -eq "SymbolicLink" } | Select-Object Name, Target
```

## Notas

- Ejecutar PowerShell **como Administrador** para crear symlinks en Windows
- Claude debe estar cerrado al crear el symlink (si ya creó la carpeta, borrarla primero con `Remove-Item`)
- En el otro ordenador: mismo comando, misma ruta de proyecto → las sesiones compartidas por git ya son visibles
