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

/* server/status/base.twig */
class __TwigTemplate_b4ddd2923efbdf9b4fbe605089b6b7e9 extends Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
            'content' => [$this, 'block_content'],
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        yield "<div class=\"container-fluid\">
  <div class=\"row\">
    <ul class=\"nav nav-pills m-2\">
      <li class=\"nav-item\">
        <a href=\"";
        // line 5
        yield PhpMyAdmin\Url::getFromRoute("/server/status");
        yield "\" class=\"nav-link";
        yield (((($context["active"] ?? null) == "status")) ? (" active") : (""));
        yield " disableAjax\">
          ";
yield _gettext("Server");
        // line 7
        yield "        </a>
      </li>
      <li class=\"nav-item\">
        <a href=\"";
        // line 10
        yield PhpMyAdmin\Url::getFromRoute("/server/status/processes");
        yield "\" class=\"nav-link";
        yield (((($context["active"] ?? null) == "processes")) ? (" active") : (""));
        yield " disableAjax\">
          ";
yield _gettext("Processes");
        // line 12
        yield "        </a>
      </li>
      <li class=\"nav-item\">
        <a href=\"";
        // line 15
        yield PhpMyAdmin\Url::getFromRoute("/server/status/queries");
        yield "\" class=\"nav-link";
        yield (((($context["active"] ?? null) == "queries")) ? (" active") : (""));
        yield " disableAjax\">
          ";
yield _gettext("Query statistics");
        // line 17
        yield "        </a>
      </li>
      <li class=\"nav-item\">
        <a href=\"";
        // line 20
        yield PhpMyAdmin\Url::getFromRoute("/server/status/variables");
        yield "\" class=\"nav-link";
        yield (((($context["active"] ?? null) == "variables")) ? (" active") : (""));
        yield " disableAjax\">
          ";
yield _gettext("All status variables");
        // line 22
        yield "        </a>
      </li>
      <li class=\"nav-item\">
        <a href=\"";
        // line 25
        yield PhpMyAdmin\Url::getFromRoute("/server/status/monitor");
        yield "\" class=\"nav-link";
        yield (((($context["active"] ?? null) == "monitor")) ? (" active") : (""));
        yield " disableAjax\">
          ";
yield _gettext("Monitor");
        // line 27
        yield "        </a>
      </li>
      <li class=\"nav-item\">
        <a href=\"";
        // line 30
        yield PhpMyAdmin\Url::getFromRoute("/server/status/advisor");
        yield "\" class=\"nav-link";
        yield (((($context["active"] ?? null) == "advisor")) ? (" active") : (""));
        yield " disableAjax\">
          ";
yield _gettext("Advisor");
        // line 32
        yield "        </a>
      </li>
    </ul>
  </div>

  ";
        // line 37
        yield from $this->unwrap()->yieldBlock('content', $context, $blocks);
        // line 38
        yield "</div>
";
        return; yield '';
    }

    // line 37
    public function block_content($context, array $blocks = [])
    {
        $macros = $this->macros;
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "server/status/base.twig";
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
        return array (  127 => 37,  121 => 38,  119 => 37,  112 => 32,  105 => 30,  100 => 27,  93 => 25,  88 => 22,  81 => 20,  76 => 17,  69 => 15,  64 => 12,  57 => 10,  52 => 7,  45 => 5,  39 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "server/status/base.twig", "C:\\Users\\user\\Desktop\\vizsgahoz szukseges\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\server\\status\\base.twig");
    }
}
