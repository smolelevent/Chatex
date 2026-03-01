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

/* server/status/processes/index.twig */
class __TwigTemplate_89cdd43c41802390e6024b3840be7ef6 extends Template
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
        $context["active"] = "processes";
        // line 1
        $this->parent = $this->loadTemplate("server/status/base.twig", "server/status/processes/index.twig", 1);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_content($context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 4
        yield "
<div class=\"card mb-3\" id=\"tableFilter\">
  <div class=\"card-header\">";
yield _gettext("Filters");
        // line 6
        yield "</div>
  <div class=\"card-body\">
    <form action=\"";
        // line 8
        yield PhpMyAdmin\Url::getFromRoute("/server/status/processes");
        yield "\" method=\"post\" class=\"row row-cols-lg-auto gy-1 gx-3 align-items-center\">
      ";
        // line 9
        yield PhpMyAdmin\Url::getHiddenInputs(($context["url_params"] ?? null));
        yield "

      <div class=\"col-12\">
        <div class=\"form-check\">
          <input class=\"form-check-input autosubmit\" type=\"checkbox\" name=\"showExecuting\" id=\"showExecuting\"";
        // line 13
        yield ((($context["is_checked"] ?? null)) ? (" checked") : (""));
        yield ">
          <label class=\"form-check-label\" for=\"showExecuting\">";
yield _gettext("Show only active");
        // line 14
        yield "</label>
        </div>
      </div>

      <div class=\"col-12\">
        <input class=\"btn btn-secondary\" type=\"submit\" value=\"";
yield _gettext("Refresh");
        // line 19
        yield "\">
      </div>
    </form>
  </div>
</div>

";
        // line 25
        yield ($context["server_process_list"] ?? null);
        yield "

<div class=\"row\">
";
        // line 28
        yield $this->env->getFilter('notice')->getCallable()(_gettext("Note: Enabling the auto refresh here might cause heavy traffic between the web server and the MySQL server."));
        yield "
</div>

<div class=\"tabLinks row\">
  <label>
    ";
yield _gettext("Refresh rate");
        // line 33
        yield ":

    <select id=\"id_refreshRate\" class=\"refreshRate\" name=\"refreshRate\">
      ";
        // line 36
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable([2, 3, 4, 5, 10, 20, 40, 60, 120, 300, 600, 1200]);
        foreach ($context['_seq'] as $context["_key"] => $context["rate"]) {
            // line 37
            yield "        <option value=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["rate"], "html", null, true);
            yield "\"";
            yield ((($context["rate"] == 5)) ? (" selected") : (""));
            yield ">
          ";
            // line 38
            if (($context["rate"] < 60)) {
                // line 39
                yield "            ";
                if (($context["rate"] == 1)) {
                    // line 40
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d second"), $context["rate"]), "html", null, true);
                    yield "
            ";
                } else {
                    // line 42
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d seconds"), $context["rate"]), "html", null, true);
                    yield "
            ";
                }
                // line 44
                yield "          ";
            } else {
                // line 45
                yield "            ";
                if ((($context["rate"] / 60) == 1)) {
                    // line 46
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d minute"), ($context["rate"] / 60)), "html", null, true);
                    yield "
            ";
                } else {
                    // line 48
                    yield "              ";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("%d minutes"), ($context["rate"] / 60)), "html", null, true);
                    yield "
            ";
                }
                // line 50
                yield "          ";
            }
            // line 51
            yield "        </option>
      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['rate'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 53
        yield "    </select>
  </label>
  <a id=\"toggleRefresh\" href=\"#\">
    ";
        // line 56
        yield PhpMyAdmin\Html\Generator::getImage("play");
        yield "
    ";
yield _gettext("Start auto refresh");
        // line 58
        yield "  </a>
</div>

";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/processes/index.twig";
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
        return array (  181 => 58,  176 => 56,  171 => 53,  164 => 51,  161 => 50,  155 => 48,  149 => 46,  146 => 45,  143 => 44,  137 => 42,  131 => 40,  128 => 39,  126 => 38,  119 => 37,  115 => 36,  110 => 33,  101 => 28,  95 => 25,  87 => 19,  79 => 14,  74 => 13,  67 => 9,  63 => 8,  59 => 6,  54 => 4,  50 => 3,  45 => 1,  43 => 2,  36 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/processes/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\processes\\index.twig");
    }
}
