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

/* server/engines/index.twig */
class __TwigTemplate_871fcc18002a7cde13f840742b9616d0 extends Template
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
        yield "<div class=\"container-fluid\">
  <div class=\"row\">
  <h2>
    ";
        // line 4
        yield PhpMyAdmin\Html\Generator::getImage("b_engine");
        yield "
    ";
yield _gettext("Storage engines");
        // line 6
        yield "  </h2>
  </div>

  <div class=\"table-responsive\">
    <table class=\"table table-striped table-hover w-auto\">
      <thead>
        <tr>
          <th scope=\"col\">";
yield _gettext("Storage Engine");
        // line 13
        yield "</th>
          <th scope=\"col\">";
yield _gettext("Description");
        // line 14
        yield "</th>
        </tr>
      </thead>
      <tbody>
        ";
        // line 18
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["engines"] ?? null));
        foreach ($context['_seq'] as $context["engine"] => $context["details"]) {
            // line 19
            yield "          <tr class=\"";
            // line 20
            yield (((((($__internal_compile_0 = $context["details"]) && is_array($__internal_compile_0) || $__internal_compile_0 instanceof ArrayAccess ? ($__internal_compile_0["Support"] ?? null) : null) == "NO") || ((($__internal_compile_1 = $context["details"]) && is_array($__internal_compile_1) || $__internal_compile_1 instanceof ArrayAccess ? ($__internal_compile_1["Support"] ?? null) : null) == "DISABLED"))) ? (" disabled") : (""));
            yield "
            ";
            // line 21
            yield ((((($__internal_compile_2 = $context["details"]) && is_array($__internal_compile_2) || $__internal_compile_2 instanceof ArrayAccess ? ($__internal_compile_2["Support"] ?? null) : null) == "DEFAULT")) ? (" marked") : (""));
            yield "\">
            <td>
              <a rel=\"newpage\" href=\"";
            // line 23
            yield PhpMyAdmin\Url::getFromRoute(("/server/engines/" . $context["engine"]));
            yield "\">
                ";
            // line 24
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($__internal_compile_3 = $context["details"]) && is_array($__internal_compile_3) || $__internal_compile_3 instanceof ArrayAccess ? ($__internal_compile_3["Engine"] ?? null) : null), "html", null, true);
            yield "
              </a>
            </td>
            <td>";
            // line 27
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($__internal_compile_4 = $context["details"]) && is_array($__internal_compile_4) || $__internal_compile_4 instanceof ArrayAccess ? ($__internal_compile_4["Comment"] ?? null) : null), "html", null, true);
            yield "</td>
          </tr>
        ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['engine'], $context['details'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 30
        yield "      </tbody>
    </table>
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
        return "server/engines/index.twig";
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
        return array (  102 => 30,  93 => 27,  87 => 24,  83 => 23,  78 => 21,  74 => 20,  72 => 19,  68 => 18,  62 => 14,  58 => 13,  48 => 6,  43 => 4,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/engines/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\engines\\index.twig");
    }
}
