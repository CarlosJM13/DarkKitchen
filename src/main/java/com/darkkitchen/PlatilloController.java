package com.darkkitchen;

import org.springframework.web.bind.annotation.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/platillos")
public class PlatilloController {

    private final String URL = "jdbc:mysql://localhost:3306/DarkKitchen";
    private final String USER = "root";     // Cambia si es necesario
    private final String PASS = "root";     // Cambia si es necesario

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // LEER (GET)
    @GetMapping
    public List<Platillo> leerPlatillos() {
        List<Platillo> lista = new ArrayList<>();
        String sql = "SELECT * FROM Platillos";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(new Platillo(
                        rs.getInt("id_platillo"),
                        rs.getString("nombre"),
                        rs.getDouble("precio"),
                        rs.getDouble("costo_preparacion")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // CREAR (POST)
    @PostMapping
    public String crearPlatillo(@RequestBody Platillo p) {
        String sql = "INSERT INTO Platillos (nombre, precio, costo_preparacion) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, p.getNombre());
            pstmt.setDouble(2, p.getPrecio());
            pstmt.setDouble(3, p.getCostoPreparacion());
            pstmt.executeUpdate();
            return "Platillo creado";
        } catch (SQLException e) { return "Error: " + e.getMessage(); }
    }

    // ELIMINAR (DELETE)
    @DeleteMapping("/{id}")
    public String eliminarPlatillo(@PathVariable int id) {
        String sql = "DELETE FROM Platillos WHERE id_platillo = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            return "Platillo eliminado";
        } catch (SQLException e) { return "Error: " + e.getMessage(); }
    }
}