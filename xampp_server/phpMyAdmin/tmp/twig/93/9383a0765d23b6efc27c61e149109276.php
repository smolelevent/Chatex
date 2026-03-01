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

/* server/status/queries/index.twig */
class __TwigTemplate_b770954fd273d335478d48a481698b73 extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->blocks = [
            'content' => [$this, 'block_content'],
        ];
    }

    protected function doGetParent(array $context)
    {
        // line 1
        return "server/status/base.twig";
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 2
        $context["active"] = "queries";
        // line 1
        $this->parent = $this->loadTemplate("server/status/base.twig", "server/status/queries/index.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_content($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 4
        yield "
";
        // line 5
        if (($context["is_data_loaded"] ?? null)) {
            // line 6
            yield "<div class=\"row\">
  <h3 id=\"serverstatusqueries\">
    ";
// l10n: Questions is the name of a MySQL Status variable
yield _gettext("Questions since startup:");
            // line 13
            yield "    ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, ($context["stats"] ?? null), "total", [], "any", false, false, false, 13), 0), "html", null, true);
            yield "
    ";
            // line 14
            yield PhpMyAdmin\Html\MySQLDocumentation::show("server-status-variables", false, null, null, "statvar_Questions");
            yield "
  </h3>
</div>

<div class=\"row\">
  <ul>
    <li>ø ";
yield _gettext("per hour:");
            // line 20
            yield " ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, ($context["stats"] ?? null), "per_hour", [], "any", false, false, false, 20), 0), "html", null, true);
            yield "</li>
    <li>ø ";
yield _gettext("per minute:");
            // line 21
            yield " ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, ($context["stats"] ?? null), "per_minute", [], "any", false, false, false, 21), 0), "html", null, true);
            yield "</li>
    ";
            // line 22
            if ((CoreExtension::getAttribute($this->env, $this->source, ($context["stats"] ?? null), "per_second", [], "any", false, false, false, 22) >= 1)) {
                // line 23
                yield "      <li>ø ";
yield _gettext("per second:");
                yield " ";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, ($context["stats"] ?? null), "per_second", [], "any", false, false, false, 23), 0), "html", null, true);
                yield "</li>
    ";
            }
            // line 25
            yield "  </ul>
</div>

<div class=\"row\">
  <table id=\"serverStatusQueriesDetails\" class=\"table table-striped table-hover sortable col-md-4 col-12 w-auto\">
    <colgroup>
      <col class=\"namecol\">
      <col class=\"valuecol\" span=\"3\">
    </colgroup>

    <thead>
      <tr>
        <th scope=\"col\">";
yield _gettext("Statements");
            // line 37
            yield "</th>
        <th class=\"text-end\" scope=\"col\">";
// l10n: # = Amount of queries
yield _gettext("#");
            // line 38
            yield "</th>
        <th class=\"text-end\" scope=\"col\">";
yield _gettext("ø per hour");
            // line 39
            yield "</th>
        <th class=\"text-end\" scope=\"col\">%</th>
      </tr>
    </thead>

    <tbody>
      ";
            // line 45
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["queries"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["query"]) {
                // line 46
                yield "        <tr>
          <th scope=\"row\">";
                // line 47
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["query"], "name", [], "any", false, false, false, 47), "html", null, true);
                yield "</th>
          <td class=\"font-monospace text-end\">";
                // line 48
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["query"], "value", [], "any", false, false, false, 48), 5, 0, true), "html", null, true);
                yield "</td>
          <td class=\"font-monospace text-end\">";
                // line 49
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["query"], "per_hour", [], "any", false, false, false, 49), 4, 1, true), "html", null, true);
                yield "</td>
          <td class=\"font-monospace text-end\">";
                // line 50
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(PhpMyAdmin\Util::formatNumber(CoreExtension::getAttribute($this->env, $this->source, $context["query"], "percentage", [], "any", false, false, false, 50), 0, 2), "html", null, true);
                yield "</td>
        </tr>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['query'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 53
            yield "    </tbody>
  </table>

  <div id=\"serverstatusquerieschart\" class=\"w-100 col-12 col-md-6\" data-chart=\"";
            // line 56
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(json_encode(($context["chart"] ?? null)), "html", null, true);
            yield "\"></div>
</div>
";
        } else {
            // line 59
            yield "  ";
            yield $this->env->getFilter('error')->getCallable()(_gettext("Not enough privilege to view query statistics."));
            yield "
";
        }
        // line 61
        yield "
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/queries/index.twig";
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
        return array (  178 => 61,  172 => 59,  166 => 56,  161 => 53,  152 => 50,  148 => 49,  144 => 48,  140 => 47,  137 => 46,  133 => 45,  125 => 39,  121 => 38,  116 => 37,  101 => 25,  93 => 23,  91 => 22,  86 => 21,  80 => 20,  70 => 14,  65 => 13,  59 => 6,  57 => 5,  54 => 4,  50 => 3,  45 => 1,  43 => 2,  36 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/queries/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\queries\\index.twig");
    }
}
