<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Réserver une place - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <div class="container">
            <h2 class="mb-4"><i class="fas fa-ticket-alt"></i> Réserver des places</h2>

            <div class="card shadow-lg mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">${seance.film.titre}</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-door-open"></i> Salle :</strong> ${seance.salle.nomSalle} (Capacité: ${seance.salle.capacite})</p>
                            <p><strong><i class="fas fa-calendar"></i> Date :</strong> ${seance.dateSeance}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-clock"></i> Heure :</strong> ${seance.heureDebut}</p>
                            <p><strong><i class="fas fa-euro-sign"></i> Prix par place :</strong> ${seance.prix}€</p>
                        </div>
                    </div>
                    <hr>
                    <div class="alert alert-info mb-0">
                        <strong><i class="fas fa-tag"></i> Tarification (Réduction enfant 50%):</strong>
                        <ul class="mb-0 mt-2">
                            <li><strong>Standard - Adulte :</strong> 80 000Ar | <strong>Enfant :</strong> 40 000Ar</li>
                            <li><strong>Premium - Adulte :</strong> 140 000Ar | <strong>Enfant :</strong> 70 000Ar</li>
                            <li><strong>VIP - Adulte :</strong> 180 000Ar | <strong>Enfant :</strong> 90 000Ar</li>
                        </ul>
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty placesDisponibles}">
                <div class="alert alert-success mb-4">
                    <i class="fas fa-check-circle"></i> <strong>${nombrePlacesDisponibles} place(s) disponible(s)</strong> sur ${seance.salle.capacite}
                </div>
                
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form method="post" action="<c:url value='/billets/reserver/${seance.idSeance}' />" id="reservationForm">
                            <div class="mb-3">
                                <label for="places" class="form-label"><strong>Sélectionner une ou plusieurs places :</strong></label>
                                <p class="text-muted small">💡 Maintenez Ctrl (Cmd sur Mac) pour sélectionner plusieurs places</p>
                                
                                <div id="placesContainer" style="height: 250px; border: 1px solid #dee2e6; border-radius: 5px; overflow-y: auto; padding: 10px;">
                                    <c:forEach var="place" items="${placesDisponibles}" varStatus="status">
                                        <div class="row mb-3 p-2 border-bottom">
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input placeCheckbox" type="checkbox" name="idPlaces" value="${place.idPlace}" id="place_${place.idPlace}">
                                                    <label class="form-check-label" for="place_${place.idPlace}">
                                                        <strong>Rang ${place.rangee} - Numéro ${place.numero}</strong>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-8">
                                                <div class="btn-group w-100" role="group" aria-label="Type de billet">
                                                    <input type="radio" class="btn-check typeBillet_${place.idPlace}" name="typesBillets_${place.idPlace}" id="adulte_${place.idPlace}" value="1">
                                                    <label class="btn btn-outline-info" for="adulte_${place.idPlace}">
                                                        <i class="fas fa-user"></i> Adulte (80 000Ar)
                                                    </label>
                                                    
                                                    <input type="radio" class="btn-check typeBillet_${place.idPlace}" name="typesBillets_${place.idPlace}" id="enfant_${place.idPlace}" value="2">
                                                    <label class="btn btn-outline-warning" for="enfant_${place.idPlace}">
                                                        <i class="fas fa-child"></i> Enfant (40 000Ar) -50%
                                                    </label>
                                                </div>
                                                <input type="hidden" name="typesBillets" value="" class="typeBilletValue_${place.idPlace}">
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-sm-flex">
                                <button type="submit" class="btn btn-primary btn-lg flex-sm-grow-1">
                                    <i class="fas fa-check"></i> Confirmer la réservation
                                </button>
                                <button type="reset" class="btn btn-secondary btn-lg flex-sm-grow-1">
                                    <i class="fas fa-redo"></i> Réinitialiser
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty placesDisponibles}">
                <div class="alert alert-warning alert-lg" role="alert">
                    <h4 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Séance complète</h4>
                    <p>Désolé, toutes les places sont réservées pour cette séance.</p>
                </div>
            </c:if>

            <div class="mt-4">
                <a href="<c:url value='/seances/liste-seances' />" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Retour aux séances
                </a>
                <a href="<c:url value='/billets/mes-reservations' />" class="btn btn-outline-primary">
                    <i class="fas fa-list"></i> Mes réservations
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Gérer la sélection des types de billet
document.addEventListener('DOMContentLoaded', function() {
    // Pour chaque checkbox place
    document.querySelectorAll('.placeCheckbox').forEach(function(checkbox) {
        // Définir un type par défaut (Adulte)
        const adulteRadio = document.getElementById('adulte_' + checkbox.value);
        if (adulteRadio) {
            adulteRadio.checked = true;
        }
    });
    
    // Mettre à jour les valeurs lors de la soumission du formulaire
    document.getElementById('reservationForm').addEventListener('submit', function(e) {
        // Récupérer toutes les places cochées
        const placesSelectionnees = document.querySelectorAll('.placeCheckbox:checked');
        
        // Supprimer les anciens champs typesBillets
        document.querySelectorAll('input[name="typesBillets"][type="hidden"]').forEach(el => el.remove());
        
        // Pour chaque place sélectionnée, récupérer le type de billet correspondant
        placesSelectionnees.forEach(function(checkbox) {
            const placeId = checkbox.value;
            
            // Chercher le type de billet sélectionné pour cette place
            const selectedRadio = document.querySelector('input[name="typesBillets_' + placeId + '"]:checked');
            
            if (selectedRadio) {
                // Ajouter un champ caché avec la valeur du type de billet
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'typesBillets';
                input.value = selectedRadio.value;
                document.getElementById('reservationForm').appendChild(input);
            }
        });
    });
});
</script>
</body>
</html>
