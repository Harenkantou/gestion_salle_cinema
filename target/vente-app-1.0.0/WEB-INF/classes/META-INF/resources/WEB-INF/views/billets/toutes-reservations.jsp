<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Toutes les Réservations - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <section class="hero p-5 text-white rounded-3 mb-4" style="background: linear-gradient(135deg, #dc3545, #6f42c1);">
            <div class="container">
                <h1 class="display-5"><i class="fas fa-list"></i> Toutes les Réservations</h1>
                <p class="lead">Dashboard administrateur - Suivi complet des réservations</p>
            </div>
        </section>

        <div class="container">
            <!-- STATISTIQUES -->
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="card shadow-sm border-danger">
                        <div class="card-body text-center">
                            <h6 class="card-title text-danger text-uppercase">Total Réservations</h6>
                            <h2 class="text-danger">${totalBillets}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm border-success">
                        <div class="card-body text-center">
                            <h6 class="card-title text-success text-uppercase">Chiffre d'Affaires</h6>
                            <h2 class="text-success">${totalRevenu}€</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm border-info">
                        <div class="card-body text-center">
                            <h6 class="card-title text-info text-uppercase">Revenu Moyen</h6>
                            <h2 class="text-info">
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
            </div>

            <c:if test="${not empty billets}">
                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead class="table-danger">
                            <tr>
                                <th><i class="fas fa-user"></i> Client</th>
                                <th><i class="fas fa-envelope"></i> Email</th>
                                <th><i class="fas fa-film"></i> Film</th>
                                <th><i class="fas fa-door-open"></i> Salle</th>
                                <th><i class="fas fa-calendar"></i> Date</th>
                                <th><i class="fas fa-clock"></i> Heure</th>
                                <th><i class="fas fa-chair"></i> Place</th>
                                <th><i class="fas fa-euro-sign"></i> Prix</th>
                                <th><i class="fas fa-check-circle"></i> Statut</th>
                                <th><i class="fas fa-calendar-alt"></i> Achat</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="billet" items="${billets}">
                                <tr>
                                    <td><strong>${billet.client.prenom} ${billet.client.nom}</strong></td>
                                    <td><small>${billet.client.email}</small></td>
                                    <td>${billet.seance.film.titre}</td>
                                    <td>${billet.seance.salle.nomSalle}</td>
                                    <td>${billet.seance.dateSeance}</td>
                                    <td>${billet.seance.heureDebut}</td>
                                    <td>Rang ${billet.place.rangee} - N° ${billet.place.numero}</td>
                                    <td><strong class="text-success">${billet.prix}€</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${billet.idStatutBillet == 1}">
                                                <span class="badge bg-warning text-dark">Réservé</span>
                                            </c:when>
                                            <c:when test="${billet.idStatutBillet == 2}">
                                                <span class="badge bg-success">Payé</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${billet.idStatutBillet}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><small class="text-muted">${billet.dateAchat}</small></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty billets}">
                <div class="alert alert-info alert-lg" role="alert">
                    <h4 class="alert-heading"><i class="fas fa-info-circle"></i> Aucune réservation</h4>
                    <p class="mb-0">Il n'y a actuellement aucune réservation dans le système.</p>
                </div>
            </c:if>

            <div class="mt-4">
                <a href="<c:url value='/billets/rapport-financier' />" class="btn btn-primary">
                    <i class="fas fa-chart-line"></i> Rapport Financier
                </a>
                <a href="<c:url value='/seances/liste-seances' />" class="btn btn-outline-secondary">
                    <i class="fas fa-search"></i> Rechercher
                </a>
                <a href="<c:url value='/' />" class="btn btn-outline-secondary">
                    <i class="fas fa-home"></i> Accueil
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
