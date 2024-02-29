bl_info = {
    "name": "Evan's Y-aligned Camera Creator",
    "author": "Evan Pratten <evan@ewpratten.com>",
    "version": (1, 0),
    "blender": (3, 0, 0),
    "description": "Adds a camera that is aligned with the Y axis by default",
    "category": "General",
}

import bpy
from bpy.types import Operator
from bpy_extras.object_utils import AddObjectHelper
import math


class OBJECT_OT_add_object(Operator, AddObjectHelper):
    """Create a new Camera Object facing +Y"""

    bl_idname = "mesh.add_y_camera"
    bl_label = "Add Camera Object facing +Y"
    bl_options = {"REGISTER", "UNDO"}

    def execute(self, _):
        print("[+Y Camera] Creating new camera and adding to scene at origin")

        # Create a new camera, facing +Y
        camera_data = bpy.data.cameras.new(name="Camera")
        camera_object = bpy.data.objects.new("Camera", camera_data)
        camera_object.rotation_euler[0] = math.radians(90)

        # Add the camera to the scene
        bpy.context.scene.collection.objects.link(camera_object)

        return {"FINISHED"}


def blender_button_add_y_camera(obj, _):
    obj.layout.operator(
        OBJECT_OT_add_object.bl_idname, text="+Y Camera", icon="CAMERA_DATA"
    )


def register():
    bpy.utils.register_class(OBJECT_OT_add_object)
    bpy.types.VIEW3D_MT_add.append(
        lambda obj, ctx: blender_button_add_y_camera(obj, ctx)
    )


def unregister():
    bpy.utils.unregister_class(OBJECT_OT_add_object)
    bpy.types.VIEW3D_MT_add.remove(
        lambda obj, ctx: blender_button_add_y_camera(obj, ctx)
    )
