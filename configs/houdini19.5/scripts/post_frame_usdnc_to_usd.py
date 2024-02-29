from pxr import Usd
from pathlib import Path

# Figure out what file just got exported
# NOTE: The filename the user enters is not the actual filename due to the NC suffix
output_file_field = Path(hou.pwd().parm("lopoutput").eval())
rendered_file = output_file_field.with_suffix(".usdnc")
print(f"[USDNC To USD]: Converting {rendered_file} to USD")

# Load the rendered stage
print("[USDNC To USD]: Loading stage")
stage = Usd.Stage.Open(str(rendered_file))

# Write it again with the appropriate extension
output_file = rendered_file.with_suffix(output_file_field.suffix)
print(f"[USDNC To USD]: Exporting to: {output_file}")
stage.Export(str(output_file))
