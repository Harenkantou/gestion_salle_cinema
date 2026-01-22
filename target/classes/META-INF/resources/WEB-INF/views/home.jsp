<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Accueil - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <section class="hero p-5 text-white rounded-3 mb-4" style="background: linear-gradient(135deg,#6f42c1,#0d6efd);">
            <div class="container">
                <h1 class="display-5">Bienvenue sur CinemaApp</h1>
                <p class="lead">Reservez vos places, consultez les seances et gerez vos billets facilement.</p>
                <p>
                    <a href="/seances/liste-seances" class="btn btn-light btn-lg me-2">Voir les seances</a>
                    <a href="/films" class="btn btn-outline-light btn-lg">Parcourir les films</a>
                </p>
            </div>
        </section>

        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Reservation rapide</h5>
                            <p class="card-text">Choisissez une seance et reservez vos places en quelques clics.</p>
                            <a href="/seances/liste-seances" class="btn btn-primary">Reserver</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Films populaires</h5>
                            <p class="card-text">Consultez la liste des films a l'affiche et leurs details.</p>
                            <a href="/films" class="btn btn-primary">Voir les films</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Gestion des salles</h5>
                            <p class="card-text">Consultez les salles et le revenu maximum qu'elles peuvent générer.</p>
                            <a href="/salles/list" class="btn btn-primary">Voir les salles</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Chiffre d'affaires</h5>
                            <p class="card-text">Visualisez le chiffre d'affaires total avec filtre par date.</p>
                            <a href="/seances/chiffre-affaires" class="btn btn-success">Voir le CA</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Mon compte</h5>
                            <p class="card-text">Accedez a vos reservations et informations personnelles.</p>
                            <a href="/login" class="btn btn-primary">Se connecter</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function(){
  // future enhancements
});
</script>
</body>
</html>