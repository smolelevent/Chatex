<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\CoreExtension;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* table/index_rename_form.twig */
class __TwigTemplate_a0ec7235b670bdd2a0cc0bd51c12fee8 extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        yield "<form action=\"";
        yield PhpMyAdmin\Url::getFromRoute("/table/indexes/rename");
        yield "\" method=\"post\" name=\"index_frm\" id=\"index_frm\" class=\"ajax\">

  ";
        // line 3
        yield PhpMyAdmin\Url::getHiddenInputs(($context["form_params"] ?? null));
        yield "

  <fieldset class=\"pma-fieldset\" id=\"index_edit_fields\">
    <div class=\"index_info\">
      <div>
          <div class=\"label\">
              <strong>
                  <label for=\"input_index_name\">
                      ";
yield _gettext("Index name:");
        // line 12
        yield "                      ";
        yield PhpMyAdmin\Html\Generator::showHint(_gettext("\"PRIMARY\" <b>must</b> be the name of and <b>only of</b> a primary key!"));
        yield "
                  </label>
              </strong>
          </div>

          <input type=\"text\"
              name=\"index[Key_name]\"
              id=\"input_index_name\"
              size=\"25\"
              maxlength=\"64\"
              value=\"";
        // line 22
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, ($context["index"] ?? null), "getName", [], "method", false, false, false, 22), "html", null, true);
        yield "\"
              onfocus=\"this.select()\">
      </div>
    </div>
  </fieldset>
  <fieldset class=\"pma-fieldset tblFooters\">
    <button class=\"btn btn-secondary\" type=\"submit\" id=\"preview_index_frm\">";
yield _gettext("Preview SQL");
        // line 28
        yield "</button>
  </fieldset>
</form>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "table/index_rename_form.twig";
    }

    /**
     * @codeCoverageIgnore
     */
    public function isTraitable()
    {
        return false;
    }

    /**
     * @codeCoverageIgnore
     */
    public function getDebugInfo()
    {
        return array (  80 => 28,  70 => 22,  56 => 12,  44 => 3,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "table/index_rename_form.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\table\\index_rename_form.twig");
    }
}
