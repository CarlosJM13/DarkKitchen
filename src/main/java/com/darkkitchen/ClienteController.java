package com.darkkitchen;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/clientes")
public class ClienteController {
    private final String URL = "jdbc:mysql://localhost:3306/DarkKitchen";
    private final String USER = "root"; // Tu usuario
    private final String PASS = "1234"; // Tu contraseña

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    @GetMapping
    public List<Cliente> leerClientes() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM Clientes";
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(new Cliente(rs.getInt("id_cliente"), rs.getString("nombre"), rs.getString("telefono"), rs.getString("direccion"), rs.getString("correo")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // POST: Llama al Procedimiento Almacenado con manejo de Excepciones (TRY/CATCH)
    @PostMapping
    public ResponseEntity<String> crearCliente(@RequestBody Cliente c) {
        String sql = "{CALL sp_InsertarClienteNuevo(?, ?, ?, ?)}";
        try (Connection conn = getConnection(); CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setString(1, c.getNombre());
            stmt.setString(2, c.getTelefono());
            stmt.setString(3, c.getDireccion());
            stmt.setString(4, c.getCorreo());

            ResultSet rs = stmt.executeQuery();
            if(rs.next()) {
                String mensaje = rs.getString("Mensaje");
                if(mensaje.contains("ERROR")) {
                    return ResponseEntity.status(400).body(mensaje); // Devuelve el error al frontend
                }
                return ResponseEntity.ok(mensaje); // Éxito
            }
        } catch (SQLException e) {
            return ResponseEntity.status(500).body("Error de servidor: " + e.getMessage());
        }
        return ResponseEntity.badRequest().build();
    }
}
