<%@ include file="/WEB-INF/views/fragments/header.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - CinemaApp</title>
</head>
<body>
<div class="d-flex" id="page-wrapper">
    <div>
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jspf" />
    </div>

    <div class="flex-grow-1 p-4">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow-lg border-0">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0">
                                <i class="fas fa-sign-in-alt"></i> Connexion à CinemaApp
                            </h3>
                        </div>
                        <div class="card-body p-5">
                            <c:if test="${param.error != null}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle"></i> Email ou mot de passe incorrect
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form method="post" action="<c:url value='/login' />">
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope"></i> Email
                                    </label>
                                    <input type="email" class="form-control form-control-lg" id="email" name="email" placeholder="votre@email.com" required />
                                </div>

                                <div class="mb-4">
                                    <label for="motdepasse" class="form-label">
                                        <i class="fas fa-lock"></i> Mot de passe
                                    </label>
                                    <input type="password" class="form-control form-control-lg" id="motdepasse" name="motdepasse" placeholder="Votre mot de passe" required />
                                </div>

                                <button type="submit" class="btn btn-primary btn-lg w-100">
                                    <i class="fas fa-sign-in-alt"></i> Se connecter
                                </button>
                            </form>

                            <hr class="my-4">

                            <div class="alert alert-info" role="alert">
                                <h5 class="alert-heading">Comptes de test disponibles :</h5>
                                <ul class="mb-0">
                                    <li><strong>jean.dupont@example.com</strong> / motdepasse</li>
                                    <li><strong>marie.martin@example.com</strong> / motdepasse</li>
                                    <li><strong>pierre.bernard@example.com</strong> / motdepasse</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
