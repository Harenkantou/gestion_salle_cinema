<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Paiements - Cinéma</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .container-main {
            max-width: 1200px;
            margin: 0 auto;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
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
            margin: 0;
        }
        .badge-solde {
            display: inline-block;
            padding: 15px 25px;
            border-radius: 10px;
            font-weight: bold;
            margin: 10px 5px;
        }
        .badge-a-payer {
            background: #ff6b6b;
            color: white;
        }
        .badge-paye {
            background: #51cf66;
            color: white;
        }
        .badge-total {
            background: #4dabf7;
            color: white;
        }
        .pourcentage-bar {
            background: linear-gradient(90deg, #51cf66 var(--percentage), #e9ecef var(--percentage));
            height: 30px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .table-row-hover:hover {
            background-color: #f8f9fa;
        }
        .montant {
            font-weight: bold;
            color: #667eea;
        }
        .montant-negatif {
            color: #ff6b6b;
        }
        .montant-positif {
            color: #51cf66;
        }
    </style>
</head>
<body>
    <jsp:include page="../fragments/header.jspf" />
    
    <div class="container-main">
        <!-- En-tête -->
        <div class="header">
            <h1><i class="fas fa-credit-card"></i> Gestion des Paiements - ${nomSociete}</h1>
            <p class="text-muted mb-0">Suivi des paiements et du solde à payer</p>
        </div>
        
        <!-- Message d'erreur -->
        <c:if test="${not empty erreur}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle"></i> ${erreur}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Récapitulatif du solde -->
        <c:if test="${not empty soldeInfo}">
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header bg-gradient" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <h5 class="card-title text-white mb-0">
                                <i class="fas fa-calculator"></i> Récapitulatif Financier
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row text-center">
                                <div class="col-md-3">
                                    <div class="badge-solde badge-total">
                                        <div style="font-size: 12px; color: rgba(255,255,255,0.8);">Total Diffusions</div>
                                        <div style="font-size: 24px;">
                                            <fmt:formatNumber value="${soldeInfo.totalDiffusions}" type="number" groupingUsed="true" />
                                        </div>
                                        <div style="font-size: 12px;">AR</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="badge-solde badge-paye">
                                        <div style="font-size: 12px; color: rgba(255,255,255,0.8);">Total Payé</div>
                                        <div style="font-size: 24px;">
                                            <fmt:formatNumber value="${soldeInfo.totalPaiements}" type="number" groupingUsed="true" />
                                        </div>
                                        <div style="font-size: 12px;">AR</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="badge-solde badge-a-payer">
                                        <div style="font-size: 12px; color: rgba(255,255,255,0.8);">Reste à Payer</div>
                                        <div style="font-size: 24px;">
                                            <fmt:formatNumber value="${soldeInfo.resteAPayer}" type="number" groupingUsed="true" />
                                        </div>
                                        <div style="font-size: 12px;">AR</div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="badge-solde" style="background: linear-gradient(135deg, #a78bfa 0%, #7c3aed 100%); color: white;">
                                        <div style="font-size: 12px; color: rgba(255,255,255,0.8);">Pourcentage Payé</div>
                                        <div style="font-size: 24px;">
                                            <fmt:formatNumber value="${soldeInfo.pourcentagePaye}" type="number" maxFractionDigits="2" />%
                                        </div>
                                        <div style="font-size: 12px;">du total</div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Barre de progression -->
                            <div class="mt-4">
                                <p class="text-center text-muted mb-2">Progression du paiement</p>
                                <div class="pourcentage-bar" style="--percentage: ${soldeInfo.pourcentagePaye}%;">
                                    <fmt:formatNumber value="${soldeInfo.pourcentagePaye}" type="number" maxFractionDigits="1" />%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Historique des paiements -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-gradient" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <h5 class="card-title text-white mb-0">
                            <i class="fas fa-history"></i> Historique des Paiements
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty historique}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th><i class="fas fa-hashtag"></i> #</th>
                                                <th><i class="fas fa-calendar"></i> Date de Paiement</th>
                                                <th><i class="fas fa-money-bill"></i> Montant (AR)</th>
                                                <th><i class="fas fa-file-alt"></i> Description</th>
                                                <th><i class="fas fa-calculator"></i> Solde Restant (AR)</th>
                                                <th class="text-center"><i class="fas fa-chart-pie"></i> % Payé</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="paiement" items="${historique}" varStatus="status">
                                                <tr class="table-row-hover">
                                                    <td>
                                                        <span class="badge bg-primary">${paiement.idPaiement}</span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td class="montant montant-positif">
                                                        + <fmt:formatNumber value="${paiement.montantPaye}" type="number" groupingUsed="true" />
                                                    </td>
                                                    <td>
                                                        <small>${paiement.description}</small>
                                                    </td>
                                                    <td class="montant">
                                                        <c:choose>
                                                            <c:when test="${paiement.resteAPayer <= 0}">
                                                                <span class="badge bg-success">Payé</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="montant-negatif">
                                                                    <fmt:formatNumber value="${paiement.resteAPayer}" type="number" groupingUsed="true" />
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge bg-info">
                                                            <fmt:formatNumber value="${paiement.pourcentagePaye}" type="number" maxFractionDigits="1" />%
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle"></i> Aucun paiement enregistré pour cette société.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Boutons d'action -->
        <div class="row mt-4 mb-5">
            <div class="col-md-12">
                <a href="/paiements/liste" class="btn btn-primary">
                    <i class="fas fa-list"></i> Voir tous les paiements
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
