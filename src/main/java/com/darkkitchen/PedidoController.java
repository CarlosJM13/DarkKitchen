package com.darkkitchen;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.sql.*;
import java.util.*;

@RestController
@RequestMapping("/api/pedidos")
public class PedidoController {
    private final String URL = "jdbc:mysql://localhost:3306/DarkKitchen";
    private final String USER = "root"; // Tu usuario de BD
    private final String PASS = "1234"; // Tu contraseña de BD

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // Recibe el carrito desde index.html y hace un INSERT con Transacciones (TCL)
    @PostMapping
    public ResponseEntity<String> realizarPedido(@RequestBody PedidoDTO pedido) {
        String sqlPedido = "INSERT INTO Pedidos (estado, total, id_plataforma, id_cliente) VALUES ('Pendiente', ?, 5, ?)"; // 5 = Propia Web
        String sqlDetalle = "INSERT INTO Detalle_Pedido (id_pedido, id_platillo, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // INICIA TRANSACCIÓN
            try (PreparedStatement psPedido = conn.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS)) {
                psPedido.setDouble(1, pedido.getTotal());
                psPedido.setInt(2, pedido.getIdCliente());
                psPedido.executeUpdate();

                ResultSet rs = psPedido.getGeneratedKeys();
                int idPedido = rs.next() ? rs.getInt(1) : 0;

                try (PreparedStatement psDetalle = conn.prepareStatement(sqlDetalle)) {
                    for (DetalleDTO det : pedido.getDetalles()) {
                        psDetalle.setInt(1, idPedido);
                        psDetalle.setInt(2, det.getIdPlatillo());
                        psDetalle.setInt(3, det.getCantidad());
                        psDetalle.setDouble(4, det.getPrecioUnitario());
                        psDetalle.addBatch();
                    }
                    psDetalle.executeBatch();
                }
                conn.commit(); // CONFIRMA TRANSACCIÓN
                return ResponseEntity.ok("Pedido procesado con éxito.");
            } catch (SQLException ex) {
                conn.rollback(); // DESHACE TRANSACCIÓN EN CASO DE ERROR
                return ResponseEntity.status(500).body("Error en la base de datos: " + ex.getMessage());
            }
        } catch (SQLException e) {
            return ResponseEntity.status(500).body("Error de conexión: " + e.getMessage());
        }
    }

    // Lee los pedidos para mostrarlos en admin.html
    @GetMapping
    public List<Map<String, Object>> obtenerPedidos() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT p.id_pedido, p.fecha, p.estado, p.total, c.nombre as cliente FROM Pedidos p JOIN Clientes c ON p.id_cliente = c.id_cliente ORDER BY p.fecha DESC";
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while(rs.next()){
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id_pedido"));
                map.put("fecha", rs.getString("fecha"));
                map.put("estado", rs.getString("estado"));
                map.put("total", rs.getDouble("total"));
                map.put("cliente", rs.getString("cliente"));
                lista.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
}

// Clases auxiliares para leer el JSON del carrito
class PedidoDTO {
    private int idCliente;
    private double total;
    private List<DetalleDTO> detalles;
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    public List<DetalleDTO> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleDTO> detalles) { this.detalles = detalles; }
}

class DetalleDTO {
    private int idPlatillo;
    private int cantidad;
    private double precioUnitario;
    public int getIdPlatillo() { return idPlatillo; }
    public void setIdPlatillo(int idPlatillo) { this.idPlatillo = idPlatillo; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }
}