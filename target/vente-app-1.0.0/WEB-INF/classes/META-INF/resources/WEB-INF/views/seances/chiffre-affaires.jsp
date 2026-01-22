<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chiffre d'affaires - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <div class="container">
            <h2 class="mb-4">Chiffre d'affaires</h2>

            <!-- Formulaire de filtre -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title">Filtrer par période</h5>
                    <form method="get">
                        <div class="row g-3">
                            <div class="col-md-5">
                                <label for="dateDebut" class="form-label">Date de début</label>
                                <input type="date" 
                                       class="form-control" 
                                       id="dateDebut" 
                                       name="dateDebut" 
                                       value="<fmt:formatDate value="${dateDebut}" pattern="yyyy-MM-dd"/>" 
                                       required>
                            </div>
                            <div class="col-md-5">
                                <label for="dateFin" class="form-label">Date de fin</label>
                                <input type="date" 
                                       class="form-control" 
                                       id="dateFin" 
                                       name="dateFin" 
                                       value="<fmt:formatDate value="${dateFin}" pattern="yyyy-MM-dd"/>" 
                                       required>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">Filtrer</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Affichage du résultat -->
            <c:if test="${not empty chiffreAffaires}">
                <div class="alert alert-info">
                    <h5>Résultat</h5>
                    <p>Chiffre d'affaires du 
                       <strong><fmt:formatDate value="${dateDebut}" pattern="dd/MM/yyyy"/></strong> 
                       au 
                       <strong><fmt:formatDate value="${dateFin}" pattern="dd/MM/yyyy"/></strong> :
                    </p>
                    <p class="fs-4">
                        <strong><fmt:formatNumber value="${chiffreAffaires}" type="currency" currencySymbol="Ar "/></strong>
                    </p>
                </div>
            </c:if>

            <!-- Message d'erreur -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>