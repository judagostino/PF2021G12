# Definir el token Bearer
$token = "1yugZxkwA0omc8uQR7QvbVWLnXgxTYnDEIc8eVSPJ800jUreiaXzUl5Co7hN0O6eDdJ2Y5KtARIg9Jv7wpEaZaNWmjU9vvfLOUzg"

# Definir la URL y el endpoint
$url = "http://comunidad-parimpar-api.com.ar/api/v1/Notify/NewEventsAndPosts"

# Bucle infinito
while ($true) {
	# Obtener la fecha y hora actual
    $currentDateTime = Get-Date
	
    # Realizar la solicitud POST con el encabezado de autorización
    $headers = @{
        "Authorization" = "Bearer $token"
    }
	try {
	    $response = Invoke-RestMethod -Uri $url -Method Post -ContentType "application/json" -Headers $headers

		# Mostrar la fecha, hora y resultado en la pantalla de la consola
        "$currentDateTime - Resultado: $response"
        
	}	
	 catch {
         # Mostrar la fecha, hora y el mensaje de error en la pantalla de la consola
        "$currentDateTime - Error: $_"
    }

    # Esperar 1 hora antes de la próxima iteración
	Start-Sleep -Seconds 3600 
}
# Agregar el siguiente comando para pausar la ejecución y mantener abierta la ventana de la CMD
Read-Host "Presiona Enter para salir"