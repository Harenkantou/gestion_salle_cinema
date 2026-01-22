package com.example.cinema.dto;

import java.util.Map;

public class RevenuDTO {
    private boolean success;
    private Double revenuMaximum;
    private Map<String, Object> detail;
    private String error;

    // Constructors
    public RevenuDTO() {}

    public RevenuDTO(Double revenuMaximum, Map<String, Object> detail) {
        this.success = true;
        this.revenuMaximum = revenuMaximum;
        this.detail = detail;
    }

    public RevenuDTO(String error) {
        this.success = false;
        this.error = error;
    }

    // Getters & Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }

    public Double getRevenuMaximum() { return revenuMaximum; }
    public void setRevenuMaximum(Double revenuMaximum) { this.revenuMaximum = revenuMaximum; }

    public Map<String, Object> getDetail() { return detail; }
    public void setDetail(Map<String, Object> detail) { this.detail = detail; }

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }
}
