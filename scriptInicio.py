import platform

print("Hola desde AWS Systems Manager")
print("Sistema operativo:", platform.system())
print("Versión:", platform.version())
print("Release:", platform.release())
print("Arquitectura:", platform.machine())