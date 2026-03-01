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

/* server/status/processes/list.twig */
class __TwigTemplate_514a4932c51b543d78f3f18cd152fb3a extends Template
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
        yield "<div class=\"responsivetable row\">
  <table id=\"tableprocesslist\" class=\"table table-striped table-hover sortable w-auto\">
    <thead>
      <tr>
        <th>";
yield _gettext("Processes");
        // line 5
        yield "</th>
        ";
        // line 6
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["columns"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["column"]) {
            // line 7
            yield "          <th scope=\"col\">
            <a href=\"";
            // line 8
            yield PhpMyAdmin\Url::getFromRoute("/server/status/processes");
            yield "\" data-post=\"";
            yield PhpMyAdmin\Url::getCommon(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "params", [], "any", false, false, false, 8), "", false);
            yield "\" class=\"sortlink\">
              ";
            // line 9
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["column"], "name", [], "any", false, false, false, 9), "html", null, true);
            yield "
              ";
            // line 10
            if (CoreExtension::getAttribute($this->env, $this->source, $context["column"], "is_sorted", [], "any", false, false, false, 10)) {
                // line 11
                yield "                <img class=\"icon ic_s_desc soimg\" alt=\"";
yield _gettext("Descending");
                // line 12
                yield "\" src=\"themes/dot.gif\" style=\"display: ";
                yield (((CoreExtension::getAttribute($this->env, $this->source, $context["column"], "sort_order", [], "any", false, false, false, 12) == "DESC")) ? ("none") : ("inline"));
                yield "\">
                <img class=\"icon ic_s_asc soimg hide\" alt=\"";
yield _gettext("Ascending");
                // line 14
                yield "\" src=\"themes/dot.gif\" style=\"display: ";
                yield (((CoreExtension::getAttribute($this->env, $this->source, $context["column"], "sort_order", [], "any", false, false, false, 14) == "DESC")) ? ("inline") : ("none"));
                yield "\">
              ";
            }
            // line 16
            yield "            </a>
            ";
            // line 17
            if (CoreExtension::getAttribute($this->env, $this->source, $context["column"], "has_full_query", [], "any", false, false, false, 17)) {
                // line 18
                yield "              <a href=\"";
                yield PhpMyAdmin\Url::getFromRoute("/server/status/processes");
                yield "\" data-post=\"";
                yield PhpMyAdmin\Url::getCommon(($context["refresh_params"] ?? null), "", false);
                yield "\">
                ";
                // line 19
                if (CoreExtension::getAttribute($this->env, $this->source, $context["column"], "is_full", [], "any", false, false, false, 19)) {
                    // line 20
                    yield "                  ";
                    yield PhpMyAdmin\Html\Generator::getImage("s_partialtext", _gettext("Truncate shown queries"), ["class" => "icon_fulltext"]);
                    // line 24
                    yield "
                ";
                } else {
                    // line 26
                    yield "                  ";
                    yield PhpMyAdmin\Html\Generator::getImage("s_fulltext", _gettext("Show full queries"), ["class" => "icon_fulltext"]);
                    // line 30
                    yield "
                ";
                }
                // line 32
                yield "              </a>
            ";
            }
            // line 34
            yield "          </th>
        ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['column'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 36
        yield "      </tr>
    </thead>

    <tbody>
      ";
        // line 40
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["rows"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["row"]) {
            // line 41
            yield "        <tr>
          <td>
            <a class=\"ajax kill_process\" href=\"";
            // line 43
            yield PhpMyAdmin\Url::getFromRoute(("/server/status/processes/kill/" . CoreExtension::getAttribute($this->env, $this->source, $context["row"], "id", [], "any", false, false, false, 43)));
            yield "\" data-post=\"";
            yield PhpMyAdmin\Url::getCommon(["kill" => CoreExtension::getAttribute($this->env, $this->source, $context["row"], "id", [], "any", false, false, false, 43)], "", false);
            yield "\">
              ";
yield _gettext("Kill");
            // line 45
            yield "            </a>
          </td>
          <td class=\"font-monospace text-end\">";
            // line 47
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "id", [], "any", false, false, false, 47), "html", null, true);
            yield "</td>
          <td>
            ";
            // line 49
            if ((CoreExtension::getAttribute($this->env, $this->source, $context["row"], "user", [], "any", false, false, false, 49) != "system user")) {
                // line 50
                yield "              <a href=\"";
                yield PhpMyAdmin\Url::getFromRoute("/server/privileges", ["username" => CoreExtension::getAttribute($this->env, $this->source,                 // line 51
$context["row"], "user", [], "any", false, false, false, 51), "hostname" => CoreExtension::getAttribute($this->env, $this->source,                 // line 52
$context["row"], "host", [], "any", false, false, false, 52), "dbname" => CoreExtension::getAttribute($this->env, $this->source,                 // line 53
$context["row"], "db", [], "any", false, false, false, 53), "tablename" => "", "routinename" => ""]);
                // line 56
                yield "\">
                ";
                // line 57
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "user", [], "any", false, false, false, 57), "html", null, true);
                yield "
              </a>
            ";
            } else {
                // line 60
                yield "              ";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "user", [], "any", false, false, false, 60), "html", null, true);
                yield "
            ";
            }
            // line 62
            yield "          </td>
          <td>";
            // line 63
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "host", [], "any", false, false, false, 63), "html", null, true);
            yield "</td>
          <td>
            ";
            // line 65
            if ((CoreExtension::getAttribute($this->env, $this->source, $context["row"], "db", [], "any", false, false, false, 65) != "")) {
                // line 66
                yield "              <a href=\"";
                yield PhpMyAdmin\Url::getFromRoute("/database/structure", ["db" => CoreExtension::getAttribute($this->env, $this->source,                 // line 67
$context["row"], "db", [], "any", false, false, false, 67)]);
                // line 68
                yield "\">
                ";
                // line 69
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "db", [], "any", false, false, false, 69), "html", null, true);
                yield "
              </a>
            ";
            } else {
                // line 72
                yield "              <em>";
yield _gettext("None");
                yield "</em>
            ";
            }
            // line 74
            yield "          </td>
          <td>";
            // line 75
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "command", [], "any", false, false, false, 75), "html", null, true);
            yield "</td>
          <td class=\"font-monospace text-end\">";
            // line 76
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "time", [], "any", false, false, false, 76), "html", null, true);
            yield "</td>
          <td>";
            // line 77
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "state", [], "any", false, false, false, 77), "html", null, true);
            yield "</td>
          ";
            // line 78
            if (($context["is_mariadb"] ?? null)) {
                // line 79
                yield "            <td>";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["row"], "progress", [], "any", false, false, false, 79), "html", null, true);
                yield "</td>
          ";
            }
            // line 81
            yield "          <td>";
            yield CoreExtension::getAttribute($this->env, $this->source, $context["row"], "info", [], "any", false, false, false, 81);
            yield "</td>
      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['row'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 83
        yield "    </tbody>
  </table>
</div>
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/processes/list.twig";
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
        return array (  235 => 83,  226 => 81,  220 => 79,  218 => 78,  214 => 77,  210 => 76,  206 => 75,  203 => 74,  197 => 72,  191 => 69,  188 => 68,  186 => 67,  184 => 66,  182 => 65,  177 => 63,  174 => 62,  168 => 60,  162 => 57,  159 => 56,  157 => 53,  156 => 52,  155 => 51,  153 => 50,  151 => 49,  146 => 47,  142 => 45,  135 => 43,  131 => 41,  127 => 40,  121 => 36,  114 => 34,  110 => 32,  106 => 30,  103 => 26,  99 => 24,  96 => 20,  94 => 19,  87 => 18,  85 => 17,  82 => 16,  76 => 14,  70 => 12,  67 => 11,  65 => 10,  61 => 9,  55 => 8,  52 => 7,  48 => 6,  45 => 5,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/processes/list.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\processes\\list.twig");
    }
}
