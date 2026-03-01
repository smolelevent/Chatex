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

/* database/routines/index.twig */
class __TwigTemplate_4c9fce8e5633c0a594177fcc3fb11bbc extends Template
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
        yield "<div class=\"container-fluid my-3\">
  <h2>
    ";
        // line 3
        yield PhpMyAdmin\Html\Generator::getIcon("b_routines", _gettext("Routines"));
        yield "
    ";
        // line 4
        yield PhpMyAdmin\Html\MySQLDocumentation::show("STORED_ROUTINES");
        yield "
  </h2>

  <div class=\"d-flex flex-wrap my-3\">";
        // line 8
        if ( !Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) {
            // line 9
            yield "    <div>
      <div class=\"input-group\">
        <div class=\"input-group-text\">
          <div class=\"form-check mb-0\">
            <input class=\"form-check-input checkall_box\" type=\"checkbox\" value=\"\" id=\"checkAllCheckbox\" form=\"rteListForm\">
            <label class=\"form-check-label\" for=\"checkAllCheckbox\">";
yield _gettext("Check all");
            // line 14
            yield "</label>
          </div>
        </div>
        <button class=\"btn btn-outline-secondary\" id=\"bulkActionExportButton\" type=\"submit\" name=\"submit_mult\" value=\"export\" form=\"rteListForm\" title=\"";
yield _gettext("Export");
            // line 17
            yield "\">
          ";
            // line 18
            yield PhpMyAdmin\Html\Generator::getIcon("b_export", _gettext("Export"));
            yield "
        </button>
        <button class=\"btn btn-outline-secondary\" id=\"bulkActionDropButton\" type=\"submit\" name=\"submit_mult\" value=\"drop\" form=\"rteListForm\" title=\"";
yield _gettext("Drop");
            // line 20
            yield "\">
          ";
            // line 21
            yield PhpMyAdmin\Html\Generator::getIcon("b_drop", _gettext("Drop"));
            yield "
        </button>
      </div>
    </div>

    <div class=\"ms-auto\">
      <div class=\"input-group\">
        <span class=\"input-group-text\">";
            // line 28
            yield PhpMyAdmin\Html\Generator::getImage("b_search", _gettext("Search"));
            yield "</span>
        <input class=\"form-control\" name=\"filterText\" type=\"text\" id=\"filterText\" value=\"\" placeholder=\"";
yield _gettext("Search");
            // line 29
            yield "\" aria-label=\"";
yield _gettext("Search");
            yield "\">
      </div>
    </div>";
        }
        // line 33
        yield "
    <div";
        // line 34
        yield (( !Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) ? (" class=\"ms-2\"") : (""));
        yield ">
      <a class=\"ajax add_anchor btn btn-primary";
        // line 35
        yield (( !($context["has_privilege"] ?? null)) ? (" disabled") : (""));
        yield "\" href=\"";
        yield PhpMyAdmin\Url::getFromRoute("/database/routines", ["db" => ($context["db"] ?? null), "table" => ($context["table"] ?? null), "add_item" => true]);
        yield "\" role=\"button\"";
        yield (( !($context["has_privilege"] ?? null)) ? (" tabindex=\"-1\" aria-disabled=\"true\"") : (""));
        yield ">
        ";
        // line 36
        yield PhpMyAdmin\Html\Generator::getIcon("b_routine_add", _gettext("Create new routine"));
        yield "
      </a>
    </div>
  </div>

  <form id=\"rteListForm\" class=\"ajax\" action=\"";
        // line 41
        yield PhpMyAdmin\Url::getFromRoute("/database/routines");
        yield "\">
    ";
        // line 42
        yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null), ($context["table"] ?? null));
        yield "

    <div id=\"nothing2display\"";
        // line 44
        yield (( !Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) ? (" class=\"hide\"") : (""));
        yield ">
      ";
        // line 45
        yield $this->env->getFilter('notice')->getCallable()(_gettext("There are no routines to display."));
        yield "
    </div>

    <table id=\"routinesTable\" class=\"table table-striped table-hover";
        // line 48
        yield ((Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) ? (" hide") : (""));
        yield " data w-auto\">
      <thead>
      <tr>
        <th></th>
        <th>";
yield _gettext("Name");
        // line 52
        yield "</th>
        <th>";
yield _gettext("Type");
        // line 53
        yield "</th>
        <th>";
yield _gettext("Returns");
        // line 54
        yield "</th>
        <th colspan=\"4\"></th>
      </tr>
      </thead>
      <tbody>
      <tr class=\"hide\">";
        // line 59
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(range(0, 7));
        foreach ($context['_seq'] as $context["_key"] => $context["i"]) {
            yield "<td></td>";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['i'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        yield "</tr>";
        // line 61
        yield ($context["rows"] ?? null);
        yield "
      </tbody>
    </table>
  </form>
</div>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "database/routines/index.twig";
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
        return array (  177 => 61,  167 => 59,  160 => 54,  156 => 53,  152 => 52,  144 => 48,  138 => 45,  134 => 44,  129 => 42,  125 => 41,  117 => 36,  109 => 35,  105 => 34,  102 => 33,  95 => 29,  90 => 28,  80 => 21,  77 => 20,  71 => 18,  68 => 17,  62 => 14,  54 => 9,  52 => 8,  46 => 4,  42 => 3,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "database/routines/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\database\\routines\\index.twig");
    }
}
