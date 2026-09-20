package com.darkkitchen;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/estadisticas")
public class EstadisticasController {

    // Asegúrate de poner aquí tu contraseña de Workbench también
    private final String URL = "jdbc:mysql://localhost:3306/DarkKitchen";
    private final String USER = "root";
    private final String PASS = "TU_CONTRASEÑA";

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    @GetMapping("/top-platillos")
    public List<Map<String, Object>> getTopPlatillos() {
        List<Map<String, Object>> lista = new ArrayList<>();
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM vw_TopPlatillos LIMIT 5")) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("nombre", rs.getString("nombre"));
                map.put("vendidos", rs.getInt("total_vendidos"));
                lista.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    @GetMapping("/clientes-frecuentes")
    public List<Map<String, Object>> getFrecuenciaClientes() {
        List<Map<String, Object>> lista = new ArrayList<>();
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM vw_FrecuenciaClientes LIMIT 5")) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("nombre", rs.getString("nombre"));
                map.put("compras", rs.getInt("compras"));
                map.put("gastado", rs.getDouble("total_gastado"));
                lista.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
}