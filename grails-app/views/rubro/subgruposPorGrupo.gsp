<label>Subgrupo</label>
<g:select name="rubro.departamento.id" id="selSubgrupo" from="${subgrupos}"
          class="col-md-12" optionKey="id" optionValue="descripcion" value="${rubro?.departamento?.id}"/>