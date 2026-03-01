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

/* server/status/status/index.twig */
class __TwigTemplate_facfb9f3efa57caccaf65e0d691580a7 extends Template
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
        $context["active"] = "status";
        // line 1
        $this->parent = $this->loadTemplate("server/status/base.twig", "server/status/status/index.twig", 1);
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
            yield "  <div class=\"row\"><h3>";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("Network traffic since startup: %s"), ($context["network_traffic"] ?? null)), "html", null, true);
            yield "</h3></div>
  <div class=\"row\"><p>";
            // line 7
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf(_gettext("This MySQL server has been running for %1\$s. It started up on %2\$s."), ($context["uptime"] ?? null), ($context["start_time"] ?? null)), "html", null, true);
            yield "</p></div>

<div class=\"row align-items-start\">
  <table class=\"table table-striped table-hover col-12 col-md-5 w-auto\">
    <thead>
      <tr>
        <th scope=\"col\">
          ";
yield _gettext("Traffic");
            // line 15
            yield "          ";
            yield PhpMyAdmin\Html\Generator::showHint(_gettext("On a busy server, the byte counters may overrun, so those statistics as reported by the MySQL server may be incorrect."));
            yield "
        </th>
        <th class=\"text-end\" scope=\"col\">#</th>
        <th class=\"text-end\" scope=\"col\">";
yield _gettext("ø per hour");
            // line 18
            yield "</th>
      </tr>
    </thead>

    <tbody>
      ";
            // line 23
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["traffic"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["each_traffic"]) {
                // line 24
                yield "        <tr>
          <th scope=\"row\">";
                // line 25
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["each_traffic"], "name", [], "any", false, false, false, 25), "html", null, true);
                yield "</th>
          <td class=\"font-monospace text-end\">";
                // line 26
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["each_traffic"], "number", [], "any", false, false, false, 26), "html", null, true);
                yield "</td>
          <td class=\"font-monospace text-end\">";
                // line 27
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["each_traffic"], "per_hour", [], "any", false, false, false, 27), "html", null, true);
                yield "</td>
        </tr>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['each_traffic'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 30
            yield "    </tbody>
  </table>

  <table class=\"table table-striped table-hover col-12 col-md-6 w-auto\">
    <thead>
      <tr>
        <th scope=\"col\">";
yield _gettext("Connections");
            // line 36
            yield "</th>
        <th class=\"text-end\" scope=\"col\">#</th>
        <th class=\"text-end\" scope=\"col\">";
yield _gettext("ø per hour");
            // line 38
            yield "</th>
        <th class=\"text-end\" scope=\"col\">%</th>
      </tr>
    </thead>

    <tbody>
      ";
            // line 44
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["connections"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["connection"]) {
                // line 45
                yield "        <tr>
          <th>";
                // line 46
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["connection"], "name", [], "any", false, false, false, 46), "html", null, true);
                yield "</th>
          <td class=\"font-monospace text-end\">";
                // line 47
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["connection"], "number", [], "any", false, false, false, 47), "html", null, true);
                yield "</td>
          <td class=\"font-monospace text-end\">";
                // line 48
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["connection"], "per_hour", [], "any", false, false, false, 48), "html", null, true);
                yield "</td>
          <td class=\"font-monospace text-end\">";
                // line 49
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["connection"], "percentage", [], "any", false, false, false, 49), "html", null, true);
                yield "</td>
        </tr>
      ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['connection'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 52
            yield "    </tbody>
  </table>
</div>

  ";
            // line 56
            if ((($context["is_primary"] ?? null) || ($context["is_replica"] ?? null))) {
                // line 57
                yield "    <p class=\"alert alert-primary clearfloat\" role=\"alert\">
      ";
                // line 58
                if ((($context["is_primary"] ?? null) && ($context["is_replica"] ?? null))) {
                    // line 59
                    yield "        ";
yield _gettext("This MySQL server works as <b>primary</b> and <b>replica</b> in <b>replication</b> process.");
                    // line 60
                    yield "      ";
                } elseif (($context["is_primary"] ?? null)) {
                    // line 61
                    yield "        ";
yield _gettext("This MySQL server works as <b>primary</b> in <b>replication</b> process.");
                    // line 62
                    yield "      ";
                } elseif (($context["is_replica"] ?? null)) {
                    // line 63
                    yield "        ";
yield _gettext("This MySQL server works as <b>replica</b> in <b>replication</b> process.");
                    // line 64
                    yield "      ";
                }
                // line 65
                yield "    </p>

    <hr class=\"clearfloat\">

    <h3>";
yield _gettext("Replication status");
                // line 69
                yield "</h3>

    ";
                // line 71
                yield ($context["replication"] ?? null);
                yield "
  ";
            }
            // line 73
            yield "
";
        } else {
            // line 75
            yield "  ";
            yield $this->env->getFilter('error')->getCallable()(_gettext("Not enough privilege to view server status."));
            yield "
";
        }
        // line 77
        yield "
";
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/status/index.twig";
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
        return array (  221 => 77,  215 => 75,  211 => 73,  206 => 71,  202 => 69,  195 => 65,  192 => 64,  189 => 63,  186 => 62,  183 => 61,  180 => 60,  177 => 59,  175 => 58,  172 => 57,  170 => 56,  164 => 52,  155 => 49,  151 => 48,  147 => 47,  143 => 46,  140 => 45,  136 => 44,  128 => 38,  123 => 36,  114 => 30,  105 => 27,  101 => 26,  97 => 25,  94 => 24,  90 => 23,  83 => 18,  75 => 15,  64 => 7,  59 => 6,  57 => 5,  54 => 4,  50 => 3,  45 => 1,  43 => 2,  36 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/status/index.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\status\\index.twig");
    }
}
