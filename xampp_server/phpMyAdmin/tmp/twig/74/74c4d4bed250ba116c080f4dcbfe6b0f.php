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

/* server/export/index.twig */
class __TwigTemplate_f9569ce373d198c0032c4742e258335a extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->blocks = [
            'title' => [$this, 'block_title'],
            'selection_options' => [$this, 'block_selection_options'],
        ];
    }

    protected function doGetParent(array $context)
    {
        // line 1
        return "export.twig";
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 25
        $context["filename_hint"] = ('' === $tmp = \Twig\Extension\CoreExtension::captureOutput((function () use (&$context, $macros, $blocks) {
            // line 26
            yield "  ";
yield _gettext("@SERVER@ will become the server name.");
            return; yield '';
        })())) ? '' : new Markup($tmp, $this->env->getCharset());
        // line 1
        $this->parent = $this->loadTemplate("export.twig", "server/export/index.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_title($context, array $blocks = [])
    {
        $macros = $this->macros;
yield _gettext("Exporting databases from the current server");
        return; yield '';
    }

    // line 5
    public function block_selection_options($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 6
        yield "  <div class=\"card mb-3\" id=\"databases_and_tables\">
    <div class=\"card-header\">";
yield _gettext("Databases");
        // line 7
        yield "</div>
    <div class=\"card-body\">
      <div class=\"mb-3\">
        <button type=\"button\" class=\"btn btn-secondary\" id=\"db_select_all\">";
yield _gettext("Select all");
        // line 10
        yield "</button>
        <button type=\"button\" class=\"btn btn-secondary\" id=\"db_unselect_all\">";
yield _gettext("Unselect all");
        // line 11
        yield "</button>
      </div>

      <select class=\"form-select\" name=\"db_select[]\" id=\"db_select\" size=\"10\" multiple aria-label=\"";
yield _gettext("Databases");
        // line 14
        yield "\">
        ";
        // line 15
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["databases"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["database"]) {
            // line 16
            yield "          <option value=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["database"], "name", [], "any", false, false, false, 16), "html", null, true);
            yield "\"";
            yield ((CoreExtension::getAttribute($this->env, $this->source, $context["database"], "is_selected", [], "any", false, false, false, 16)) ? (" selected") : (""));
            yield ">
            ";
            // line 17
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["database"], "name", [], "any", false, false, false, 17), "html", null, true);
            yield "
          </option>
        ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['database'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 20
        yield "      </select>
    </div>
  </div>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/export/index.twig";
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
        return array (  111 => 20,  102 => 17,  95 => 16,  91 => 15,  88 => 14,  82 => 11,  78 => 10,  72 => 7,  68 => 6,  64 => 5,  56 => 3,  51 => 1,  46 => 26,  44 => 25,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/export/index.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\export\\index.twig");
    }
}
