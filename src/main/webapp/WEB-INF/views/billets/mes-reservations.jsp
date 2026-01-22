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
                            <h5 class="card-title"><i class="fas fa-user"></i> Mon Compte</h5>
                            <p class="mb-1"><strong>Client:</strong> ${client.prenom} ${client.nom}</p>
                            <p class="mb-0"><strong>Email:</strong> ${client.email}</p>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="card shadow-sm border-success">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-chart-bar"></i> Résumé</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-0"><strong>Total de réservations :</strong> 
                                        <span class="badge bg-primary">${billets.size()}</span>
                                    </p>
                                    <p class="mb-0"><strong>Dépense totale :</strong> 
                                        <span class="badge bg-success" style="font-size: 16px;">
                                            <c:set var="total" value="0" />
                                            <c:forEach var="billet" items="${billets}">
                                                <c:set var="total" value="${total + billet.prix}" />
                                            </c:forEach>
                                            ${total}€
                                        </span>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <c:set var="countAdultes" value="0" />
                                    <c:set var="countEnfants" value="0" />
                                    <c:forEach var="billet" items="${billets}">
                                        <c:if test="${billet.typeBillet != null && !billet.typeBillet.isEnfant}">
                                            <c:set var="countAdultes" value="${countAdultes + 1}" />
                                        </c:if>
                                        <c:if test="${billet.typeBillet != null && billet.typeBillet.isEnfant}">
                                            <c:set var="countEnfants" value="${countEnfants + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    <p class="mb-0"><strong><i class="fas fa-user"></i> Billets adultes :</strong> 
                                        <span class="badge bg-info">${countAdultes}</span>
                                    </p>
                                    <p class="mb-0"><strong><i class="fas fa-child"></i> Billets enfants :</strong> 
                                        <span class="badge bg-warning">${countEnfants}</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead class="table-primary">
                            <tr>
                                <th><i class="fas fa-film"></i> Film</th>
                                <th><i class="fas fa-door-open"></i> Salle</th>
                                <th><i class="fas fa-calendar"></i> Date</th>
                                <th><i class="fas fa-clock"></i> Heure</th>
                                <th><i class="fas fa-chair"></i> Place</th>
                                <th><i class="fas fa-tag"></i> Type</th>
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
                                    <td>Rang ${billet.place.rangee} - N° ${billet.place.numero} <span class="badge bg-light text-dark">${billet.place.typePlace.libelle}</span></td>
                                    <td>
                                        <c:if test="${billet.typeBillet != null}">
                                            <c:choose>
                                                <c:when test="${billet.typeBillet.isEnfant}">
                                                    <span class="badge bg-warning"><i class="fas fa-child"></i> Enfant</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info"><i class="fas fa-user"></i> Adulte</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </td>
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
                    <p class="mb-0">Vous n'avez pas encore de réservation. Commencez par consulter nos séances !</p>
                </div>
            </c:if>

            <div class="mt-4">
                <a href="<c:url value='/seances/liste-seances' />" class="btn btn-primary">
                    <i class="fas fa-search"></i> Trouver une séance
                </a>
                <a href="<c:url value='/billets/rapport-financier' />" class="btn btn-info">
                    <i class="fas fa-chart-line"></i> Rapport financier
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
