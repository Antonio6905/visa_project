<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/header.jsp" %>

<main class="container pb-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-file-earmark-plus me-2"></i>Formulaire Visa Transformable
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="#" class="row g-3">
                        <div class="col-md-6">
                            <label for="idPasseport" class="form-label">ID Passeport</label>
                            <input type="number" class="form-control" id="idPasseport" name="id_passeport" required>
                        </div>

                        <div class="col-md-6">
                            <label for="numero" class="form-label">Numero</label>
                            <input type="text" class="form-control" id="numero" name="numero" maxlength="50" required>
                        </div>

                        <div class="col-md-6">
                            <label for="dateEntreeTerritoire" class="form-label">Date entree territoire</label>
                            <input type="date" class="form-control" id="dateEntreeTerritoire" name="date_entree_territoire" required>
                        </div>

                        <div class="col-md-6">
                            <label for="lieuEntreeTerritoire" class="form-label">Lieu entree territoire</label>
                            <input type="text" class="form-control" id="lieuEntreeTerritoire" name="lieu_entree_territoire" maxlength="200" required>
                        </div>

                        <div class="col-md-6">
                            <label for="numeroVisaTransformable" class="form-label">Numero visa transformable</label>
                            <input type="text" class="form-control" id="numeroVisaTransformable" name="numero_visa_transformable" maxlength="50" required>
                        </div>

                        <div class="col-md-6">
                            <label for="dateSortieTerritoire" class="form-label">Date sortie territoire</label>
                            <input type="date" class="form-control" id="dateSortieTerritoire" name="date_sortie_territoire">
                        </div>

                        <div class="col-12 d-flex justify-content-end gap-2">
                            <button type="reset" class="btn btn-outline-secondary">Reinitialiser</button>
                            <button type="submit" class="btn btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="includes/footer.jsp" %>
