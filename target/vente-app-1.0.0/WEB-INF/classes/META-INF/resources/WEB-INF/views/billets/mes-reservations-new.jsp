<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Mes Réservations - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <section class="hero p-5 text-white rounded-3 mb-4" style="background: linear-gradient(135deg, #0d6efd, #6f42c1);">
            <div class="container">
                <h1 class="display-5"><i class="fas fa-ticket-alt"></i> Mes Réservations</h1>
                <p class="lead">Consultez et gérez toutes vos réservations</p>
            </div>
        </section>

        <div class="container">
            <c:if test="${not empty billets}">
                <div class="mb-4">
                    <div class="card shadow-sm border-info">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-info-circle"></i> Résumé</h5>
                            <p class="mb-0"><strong>Total de réservations :</strong> ${billets.size()}</p>
                            <p class="mb-0"><strong>Dépense totale :</strong> 
                                <span class="badge bg-success">
                                    <c:set var="total" value="0" />
                                    <c:forEach var="billet" items="${billets}">
                                        <c:set var="total" value="${total + billet.prix}" />
                                    </c:forEach>
                                    ${total}€
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th><i class="fas fa-film"></i> Film</th>
                                <th><i class="fas fa-door-open"></i> Salle</th>
                                <th><i class="fas fa-calendar"></i> Date</th>
                                <th><i class="fas fa-clock"></i> Heure</th>
                                <th><i class="fas fa-chair"></i> Place</th>
                                <th><i class="fas fa-euro-sign"></i> Prix</th>
                                <th><i class="fas fa-check-circle"></i> Statut</th>
                                <th><i class="fas fa-calendar-alt"></i> Achat</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="billet" items="${billets}">
                                <tr>
                                    <td><strong>${billet.seance.film.titre}</strong></td>
                                    <td>${billet.seance.salle.nomSalle}</td>
                                    <td>${billet.seance.dateSeance}</td>
                                    <td>${billet.seance.heureDebut}</td>
                                    <td>Rang ${billet.place.rangee} - Numéro ${billet.place.numero}</td>
                                    <td><strong>${billet.prix}€</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${billet.idStatutBillet == 1}">
                                                <span class="badge bg-warning">Réservé</span>
                                            </c:when>
                                            <c:when test="${billet.idStatutBillet == 2}">
                                                <span class="badge bg-success">Payé</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${billet.idStatutBillet}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><small>${billet.dateAchat}</small></td>
                                    <td>
                                        <form method="post" action="<c:url value='/billets/annuler/${billet.idBillet}' />" style="display:inline;">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Êtes-vous sûr de vouloir annuler cette réservation ?');">
                                                <i class="fas fa-trash-alt"></i> Annuler
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty billets}">
                <div class="alert alert-info alert-lg" role="alert">
                    <h4 class="alert-heading"><i class="fas fa-info-circle"></i> Aucune réservation</h4>
                    <p>Vous n'avez pas encore de réservation. Commencez par consulter nos séances !</p>
                </div>
            </c:if>

            <div class="mt-4">
                <a href="<c:url value='/seances/liste-seances' />" class="btn btn-primary">
                    <i class="fas fa-search"></i> Trouver une séance
                </a>
                <a href="<c:url value='/' />" class="btn btn-outline-secondary">
                    <i class="fas fa-home"></i> Retour à l'accueil
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
