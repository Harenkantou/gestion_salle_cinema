<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Paiements - Cinéma</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .container-main {
            max-width: 1400px;
            margin: 0 auto;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        .header {
            background: white;
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        .header h1 {
            color: #667eea;
            font-weight: bold;
        }
        .societe-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        .societe-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
        }
        .societe-header h3 {
            margin: 0;
            font-weight: bold;
        }
        .info-solde {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
        .info-box {
            text-align: center;
        }
        .info-label {
            font-size: 12px;
            color: #6c757d;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        .info-value {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
        }
        .table-container {
            padding: 20px;
        }
        .badge-status {
            padding: 8px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-paye {
            background: #d4edda;
            color: #155724;
        }
        .badge-partiellement {
            background: #fff3cd;
            color: #856404;
        }
    </style>
</head>
<body>
    <jsp:include page="../fragments/header.jspf" />
    
    <div class="container-main">
        <!-- En-tête -->
        <div class="header">
            <h1><i class="fas fa-file-invoice-dollar"></i> Liste Complète des Paiements</h1>
            <p class="text-muted mb-0">Suivi des paiements pour toutes les sociétés de diffusion</p>
        </div>
        
        <!-- VANIALA -->
        <div class="societe-card">
            <div class="societe-header">
                <h3><i class="fas fa-building"></i> VANIALA</h3>
            </div>
            
            <c:if test="${not empty vanialaInfo}">
                <div class="info-solde">
                    <div class="info-box">
                        <div class="info-label">Total Diffusions</div>
                        <div class="info-value">
                            <fmt:formatNumber value="${vanialaInfo.totalDiffusions}" type="number" groupingUsed="true" />
                        </div>
                        <small class="text-muted">AR</small>
                    </div>
                    <div class="info-box">
                        <div class="info-label">Total Payé</div>
                        <div class="info-value" style="color: #51cf66;">
                            <fmt:formatNumber value="${vanialaInfo.totalPaiements}" type="number" groupingUsed="true" />
                        </div>
                        <small class="text-muted">AR</small>
                    </div>
                    <div class="info-box">
                        <div class="info-label">Reste à Payer</div>
                        <div class="info-value" style="color: #ff6b6b;">
                            <fmt:formatNumber value="${vanialaInfo.resteAPayer}" type="number" groupingUsed="true" />
                        </div>
                        <small class="text-muted">AR</small>
                    </div>
                    <div class="info-box">
                        <div class="info-label">Pourcentage</div>
                        <div class="info-value" style="color: #4dabf7;">
                            <fmt:formatNumber value="${vanialaInfo.pourcentagePaye}" type="number" maxFractionDigits="1" />%
                        </div>
                        <small class="text-muted">Payé</small>
                    </div>
                </div>
            </c:if>
            
            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty historiqueVaniala}">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Montant</th>
                                        <th>Description</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="paiement" items="${historiqueVaniala}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    + <fmt:formatNumber value="${paiement.montantPaye}" type="number" groupingUsed="true" /> AR
                                                </strong>
                                            </td>
                                            <td>
                                                <small>${paiement.description}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${paiement.resteAPayer <= 0}">
                                                        <span class="badge-status badge-paye">✓ Entièrement payé</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status badge-partiellement">⚠ Partiellement payé</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle"></i> Aucun paiement enregistré.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- LEWIS -->
        <div class="societe-card">
            <div class="societe-header" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                <h3><i class="fas fa-building"></i> LEWIS</h3>
            </div>
            
            <c:if test="${not empty lewisInfo}">
                <div class="info-solde">
                    <div class="info-box">
                        <div class="info-label">Total Diffusions</div>
                        <div class="info-value">
                            <fmt:formatNumber value="${lewisInfo.totalDiffusions}" type="number" groupingUsed="true" />
                        </div>
                        <small class="text-muted">AR</small>
                    </div>
                    <div class="info-box">
                        <div class="info-label">Total Payé</div>
                        <div class="info-value" style="color: #51cf66;">
                            <fmt:formatNumber value="${lewisInfo.totalPaiements}" type="number" groupingUsed="true" />
                        </div>
                        <small class="text-muted">AR</small>
                    </div>
                    <div class="info-box">
                        <div class="info-label">Reste à Payer</div>
                        <div class="info-value" style="color: #ff6b6b;">
                            <fmt:formatNumber value="${lewisInfo.resteAPayer}" type="number" groupingUsed="true" />
                        </div>
                        <small class="text-muted">AR</small>
                    </div>
                    <div class="info-box">
                        <div class="info-label">Pourcentage</div>
                        <div class="info-value" style="color: #4dabf7;">
                            <fmt:formatNumber value="${lewisInfo.pourcentagePaye}" type="number" maxFractionDigits="1" />%
                        </div>
                        <small class="text-muted">Payé</small>
                    </div>
                </div>
            </c:if>
            
            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty historiqueLewis}">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Montant</th>
                                        <th>Description</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="paiement" items="${historiqueLewis}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    + <fmt:formatNumber value="${paiement.montantPaye}" type="number" groupingUsed="true" /> AR
                                                </strong>
                                            </td>
                                            <td>
                                                <small>${paiement.description}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${paiement.resteAPayer <= 0}">
                                                        <span class="badge-status badge-paye">✓ Entièrement payé</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status badge-partiellement">⚠ Partiellement payé</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle"></i> Aucun paiement enregistré.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Boutons d'action -->
        <div class="row mt-4 mb-5">
            <div class="col-md-12">
                <a href="/paiements/vaniala" class="btn btn-primary">
                    <i class="fas fa-eye"></i> Détail Vaniala
                </a>
                <a href="/" class="btn btn-secondary">
                    <i class="fas fa-home"></i> Retour à l'accueil
                </a>
            </div>
        </div>
    </div>
    
    <jsp:include page="../fragments/sidebar.jspf" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
