package com.darkkitchen;

public class Platillo {
    private int idPlatillo;
    private String nombre;
    private double precio;
    private double costoPreparacion;

    // Constructores vacíos y llenos
    public Platillo() {}

    public Platillo(int idPlatillo, String nombre, double precio, double costoPreparacion) {
        this.idPlatillo = idPlatillo;
        this.nombre = nombre;
        this.precio = precio;
        this.costoPreparacion = costoPreparacion;
    }

    // Getters y Setters
    public int getIdPlatillo() { return idPlatillo; }
    public void setIdPlatillo(int idPlatillo) { this.idPlatillo = idPlatillo; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
    public double getCostoPreparacion() { return costoPreparacion; }
    public void setCostoPreparacion(double costoPreparacion) { this.costoPreparacion = costoPreparacion; }
}