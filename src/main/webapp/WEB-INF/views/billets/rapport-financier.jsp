<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rapport Financier - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <section class="hero p-5 text-white rounded-3 mb-4" style="background: linear-gradient(135deg, #198754, #0d6efd);">
            <div class="container">
                <h1 class="display-5">💰 Rapport Financier</h1>
                <p class="lead">Consultez le chiffre d'affaires et les statistiques de réservation</p>
            </div>
        </section>

        <div class="container">
            <!-- RÉSUMÉ GÉNÉRAL -->
            <div class="row g-4 mb-5">
                <div class="col-md-3">
                    <div class="card shadow-sm border-success">
                        <div class="card-body text-center">
                            <h6 class="card-title text-success text-uppercase">Chiffre d'Affaires Total</h6>
                            <h2 class="text-success">${totalRevenu}€</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm border-info">
                        <div class="card-body text-center">
                            <h6 class="card-title text-info text-uppercase">Nombre de Billets</h6>
                            <h2 class="text-info">${totalBillets}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm border-warning">
                        <div class="card-body text-center">
                            <h6 class="card-title text-warning text-uppercase">Revenu Moyen/Billet</h6>
                            <h2 class="text-warning">
                                <c:if test="${totalBillets > 0}">
                                    ${Math.round(totalRevenu / totalBillets * 100) / 100}€
                                </c:if>
                                <c:if test="${totalBillets == 0}">
                                    0€
                                </c:if>
                            </h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow-sm border-primary">
                        <div class="card-body">
                            <h6 class="card-title text-primary text-uppercase">Répartition Clients</h6>
                            <p class="mb-1"><i class="fas fa-user text-info"></i> <strong>Adultes:</strong> ${totalAdultes}</p>
                            <p class="mb-0"><i class="fas fa-child text-warning"></i> <strong>Enfants:</strong> ${totalEnfants}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- REVENU PAR TYPE DE CLIENT -->
            <div class="row g-4 mb-5">
                <div class="col-md-6">
                    <div class="card shadow-sm border-info">
                        <div class="card-body text-center">
                            <h6 class="card-title text-info text-uppercase"><i class="fas fa-user"></i> Revenu Adultes</h6>
                            <h2 class="text-info">${revenuAdultes}€</h2>
                            <p class="text-muted mb-0"><small>${totalAdultes} billet(s)</small></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow-sm border-warning">
                        <div class="card-body text-center">
                            <h6 class="card-title text-warning text-uppercase"><i class="fas fa-child"></i> Revenu Enfants</h6>
                            <h2 class="text-warning">${revenuEnfants}€</h2>
                            <p class="text-muted mb-0"><small>${totalEnfants} billet(s)</small></p>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${totalBillets > 0}">
            <!-- CHIFFRE D'AFFAIRES PAR FILM -->
            <h3 class="mt-5 mb-4 text-primary"><i class="fas fa-film"></i> Chiffre d'Affaires par Film</h3>
            <c:if test="${not empty revenueParFilm}">
                <div class="table-responsive mb-5">
                    <table class="table table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th>Film</th>
                                <th class="text-end">Revenu (€)</th>
                                <th class="text-end">% du Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${revenueParFilm}">
                                <tr>
                                    <td>${entry.key}</td>
                                    <td class="text-end"><strong>${entry.value}€</strong></td>
                                    <td class="text-end"><span class="badge bg-success">${Math.round((entry.value / totalRevenu) * 100)}%</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="card mb-5 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <strong><i class="fas fa-chart-bar"></i> Visualisation par Film</strong>
                    </div>
                    <div class="card-body">
                        <c:forEach var="entry" items="${revenueParFilm}">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <span>${entry.key}</span>
                                    <span class="badge bg-info">${Math.round((entry.value / totalRevenu) * 100)}%</span>
                                </div>
                                <div class="progress" style="height: 25px;">
                                    <div class="progress-bar bg-success" style="width: ${(entry.value / totalRevenu) * 100}%;" role="progressbar">
                                        ${Math.round((entry.value / totalRevenu) * 100)}%
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- CHIFFRE D'AFFAIRES PAR SALLE -->
            <h3 class="mt-5 mb-4 text-primary"><i class="fas fa-door-open"></i> Chiffre d'Affaires par Salle</h3>
            <c:if test="${not empty revenueParSalle}">
                <div class="table-responsive mb-5">
                    <table class="table table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th>Salle</th>
                                <th class="text-end">Revenu (€)</th>
                                <th class="text-end">% du Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${revenueParSalle}">
                                <tr>
                                    <td>${entry.key}</td>
                                    <td class="text-end"><strong>${entry.value}€</strong></td>
                                    <td class="text-end"><span class="badge bg-info">${Math.round((entry.value / totalRevenu) * 100)}%</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="card mb-5 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <strong><i class="fas fa-chart-bar"></i> Visualisation par Salle</strong>
                    </div>
                    <div class="card-body">
                        <c:forEach var="entry" items="${revenueParSalle}">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <span>${entry.key}</span>
                                    <span class="badge bg-warning">${Math.round((entry.value / totalRevenu) * 100)}%</span>
                                </div>
                                <div class="progress" style="height: 25px;">
                                    <div class="progress-bar bg-warning" style="width: ${(entry.value / totalRevenu) * 100}%;" role="progressbar">
                                        ${Math.round((entry.value / totalRevenu) * 100)}%
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- CHIFFRE D'AFFAIRES PAR DATE -->
            <h3 class="mt-5 mb-4 text-primary"><i class="fas fa-calendar"></i> Chiffre d'Affaires par Date</h3>
            <c:if test="${not empty revenueParDate}">
                <div class="table-responsive mb-5">
                    <table class="table table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th>Date</th>
                                <th class="text-end">Revenu (€)</th>
                                <th class="text-end">% du Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${revenueParDate}">
                                <tr>
                                    <td>${entry.key}</td>
                                    <td class="text-end"><strong>${entry.value}€</strong></td>
                                    <td class="text-end"><span class="badge bg-danger">${Math.round((entry.value / totalRevenu) * 100)}%</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="card mb-5 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <strong><i class="fas fa-chart-bar"></i> Visualisation par Date</strong>
                    </div>
                    <div class="card-body">
                        <c:forEach var="entry" items="${revenueParDate}">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <span>${entry.key}</span>
                                    <span class="badge bg-danger">${Math.round((entry.value / totalRevenu) * 100)}%</span>
                                </div>
                                <div class="progress" style="height: 25px;">
                                    <div class="progress-bar bg-danger" style="width: ${(entry.value / totalRevenu) * 100}%;" role="progressbar">
                                        ${Math.round((entry.value / totalRevenu) * 100)}%
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

        </c:if>

        <c:if test="${totalBillets == 0}">
            <div class="alert alert-warning text-center mt-5" role="alert">
                <h5>Aucune réservation enregistrée pour le moment.</h5>
                <p>Les revenus apparaîtront ici une fois que des billets seront réservés.</p>
            </div>
        </c:if>

        <!-- ACTIONS -->
        <div class="mb-5 text-center">
            <a href="/billets/toutes-reservations" class="btn btn-primary btn-lg me-2">
                <i class="fas fa-list"></i> Toutes les Réservations
            </a>
            <a href="/seances/liste-seances" class="btn btn-info btn-lg me-2">
                <i class="fas fa-film"></i> Séances
            </a>
            <a href="/logout" class="btn btn-danger btn-lg">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
