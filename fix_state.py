import re

with open("lib/screen/registro_propiedad_screen.dart", "r") as f:
    content = f.read()

# Add didUpdateWidget
did_update_widget = """  @override
  void didUpdateWidget(covariant RegistroPropiedadScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.propertyType != widget.propertyType) {
      _emitPropertyDetails();
    }
  }

  @override
  void
  initState() {"""

content = content.replace("  @override\n  void\n  initState() {", did_update_widget)

# Replace setState with _updateState inside widget builds, but careful not to replace the one inside _updateState itself!
# We can just replace all "setState(" with "_updateState(" EXCEPT the one on line 217.

def replace_except_first(match):
    global count
    count += 1
    if count == 1: # The one in _updateState
        return "setState("
    return "_updateState("

count = 0
content = re.sub(r'setState\(', replace_except_first, content)

with open("lib/screen/registro_propiedad_screen.dart", "w") as f:
    f.write(content)
