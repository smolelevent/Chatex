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

/* table/delete/confirm.twig */
class __TwigTemplate_ee968dad5aa3db8371432102e9ad47bb extends Template
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
        yield PhpMyAdmin\Url::getFromRoute("/table/delete/rows");
        yield "\" method=\"post\">
  ";
        // line 2
        yield PhpMyAdmin\Url::getHiddenInputs(["db" =>         // line 3
($context["db"] ?? null), "table" =>         // line 4
($context["table"] ?? null), "selected" =>         // line 5
($context["selected"] ?? null), "original_sql_query" =>         // line 6
($context["sql_query"] ?? null), "fk_checks" => "0"]);
        // line 8
        yield "

  <fieldset class=\"pma-fieldset confirmation\">
    <legend>
      ";
yield _gettext("Do you really want to execute the following query?");
        // line 13
        yield "    </legend>

    <ul>
      ";
        // line 16
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["selected"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["row"]) {
            // line 17
            yield "        <li><code>DELETE FROM ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::backquote(($context["table"] ?? null)), "html", null, true);
            yield " WHERE ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["row"], "html", null, true);
            yield ";</code></li>
      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['row'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 19
        yield "    </ul>
  </fieldset>

  <fieldset class=\"pma-fieldset tblFooters\">
    <div id=\"foreignkeychk\" class=\"float-start\">
      <input type=\"checkbox\" name=\"fk_checks\" id=\"fk_checks\" value=\"1\"";
        // line 24
        yield ((($context["is_foreign_key_check"] ?? null)) ? (" checked") : (""));
        yield ">
      <label for=\"fk_checks\">";
yield _gettext("Enable foreign key checks");
        // line 25
        yield "</label>
    </div>
    <div class=\"float-end\">
      <input id=\"buttonYes\" class=\"btn btn-secondary\" type=\"submit\" name=\"mult_btn\" value=\"";
yield _gettext("Yes");
        // line 28
        yield "\">
      <input id=\"buttonNo\" class=\"btn btn-secondary\" type=\"submit\" name=\"mult_btn\" value=\"";
yield _gettext("No");
        // line 29
        yield "\">
    </div>
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
        return "table/delete/confirm.twig";
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
        return array (  98 => 29,  94 => 28,  88 => 25,  83 => 24,  76 => 19,  65 => 17,  61 => 16,  56 => 13,  49 => 8,  47 => 6,  46 => 5,  45 => 4,  44 => 3,  43 => 2,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "table/delete/confirm.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\table\\delete\\confirm.twig");
    }
}
