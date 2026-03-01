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

/* preferences/two_factor/main.twig */
class __TwigTemplate_fa9ecaa8afd7a4cbac09e41e01f6cdea extends Template
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
        yield "<div class=\"row\">
  <div class=\"col\">
    <div class=\"card mt-4\">
      <div class=\"card-header\">
        ";
yield _gettext("Two-factor authentication status");
        // line 6
        yield "        ";
        yield PhpMyAdmin\Html\MySQLDocumentation::showDocumentation("two_factor");
        yield "
      </div>
      <div class=\"card-body\">
    ";
        // line 9
        if (($context["enabled"] ?? null)) {
            // line 10
            yield "      ";
            if ((($context["num_backends"] ?? null) == 0)) {
                // line 11
                yield "        <p>";
yield _gettext("Two-factor authentication is not available, please install optional dependencies to enable authentication backends.");
                yield "</p>
        <p>";
yield _gettext("Following composer packages are missing:");
                // line 12
                yield "</p>
        <ul>
          ";
                // line 14
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(($context["missing"] ?? null));
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 15
                    yield "            <li><code>";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["item"], "dep", [], "any", false, false, false, 15), "html", null, true);
                    yield "</code> (";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["item"], "class", [], "any", false, false, false, 15), "html", null, true);
                    yield ")</li>
          ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 17
                yield "        </ul>
      ";
            } else {
                // line 19
                yield "        ";
                if (($context["backend_id"] ?? null)) {
                    // line 20
                    yield "          <p>";
yield _gettext("Two-factor authentication is available and configured for this account.");
                    yield "</p>
        ";
                } else {
                    // line 22
                    yield "          <p>";
yield _gettext("Two-factor authentication is available, but not configured for this account.");
                    yield "</p>
        ";
                }
                // line 24
                yield "        ";
                if ((Twig\Extension\CoreExtension::length($this->env->getCharset(), ($context["missing"] ?? null)) > 0)) {
                    // line 25
                    yield "          <p>
            ";
                    // line 26
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(_gettext("Please install optional dependencies to enable more authentication backends."), "html", null, true);
                    yield "
            ";
                    // line 27
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(_gettext("Following composer packages are missing:"), "html", null, true);
                    yield "
          </p>
          <ul>
            ";
                    // line 30
                    $context['_parent'] = $context;
                    $context['_seq'] = CoreExtension::ensureTraversable(($context["missing"] ?? null));
                    foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                        // line 31
                        yield "              <li><code>";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["item"], "dep", [], "any", false, false, false, 31), "html", null, true);
                        yield "</code> (";
                        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["item"], "class", [], "any", false, false, false, 31), "html", null, true);
                        yield ")</li>
            ";
                    }
                    $_parent = $context['_parent'];
                    unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                    $context = array_intersect_key($context, $_parent) + $_parent;
                    // line 33
                    yield "          </ul>
        ";
                }
                // line 35
                yield "      ";
            }
            // line 36
            yield "    ";
        } else {
            // line 37
            yield "      <p>";
yield _gettext("Two-factor authentication is not available, enable phpMyAdmin configuration storage to use it.");
            yield "</p>
    ";
        }
        // line 39
        yield "      </div>
    </div>
  </div>
</div>

";
        // line 44
        if (($context["backend_id"] ?? null)) {
            // line 45
            yield "<div class=\"row\">
  <div class=\"col\">
    <div class=\"card mt-4\">
      <div class=\"card-header\">
        ";
            // line 49
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["backend_name"] ?? null), "html", null, true);
            yield "
      </div>
      <div class=\"card-body\">
      <p>";
yield _gettext("You have enabled two factor authentication.");
            // line 52
            yield "</p>
      <p>";
            // line 53
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["backend_description"] ?? null), "html", null, true);
            yield "</p>
      ";
            // line 54
            if ((($context["backend_id"] ?? null) == "key")) {
                // line 55
                yield "        <div class=\"alert alert-danger\" role=\"alert\">
          <h4 class=\"alert-heading\">";
                // line 56
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(_gettext("Deprecated!"), "html", null, true);
                yield "</h4>
          <p>";
                // line 57
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(_gettext("The FIDO U2F API has been deprecated in favor of the Web Authentication API (WebAuthn)."), "html", null, true);
                yield "</p>
          <p class=\"mb-0\">
            ";
                // line 59
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(_gettext("You can still use Firefox to authenticate your account using the FIDO U2F API, however it's recommended that you use the WebAuthn authentication instead."), "html", null, true);
                yield "
          </p>
        </div>
      ";
            }
            // line 63
            yield "      <form method=\"post\" action=\"";
            yield PhpMyAdmin\Url::getFromRoute("/preferences/two-factor");
            yield "\">
        ";
            // line 64
            yield PhpMyAdmin\Url::getHiddenInputs();
            yield "
        <input class=\"btn btn-secondary\" type=\"submit\" name=\"2fa_remove\" value=\"";
yield _gettext("Disable two-factor authentication");
            // line 66
            yield "\">
      </form>
      </div>
    </div>
  </div>
</div>
";
        } elseif ((        // line 72
($context["num_backends"] ?? null) > 0)) {
            // line 73
            yield "<div class=\"row\">
  <div class=\"col\">
    <div class=\"card mt-4\">
      <div class=\"card-header\">
        ";
yield _gettext("Configure two-factor authentication");
            // line 78
            yield "      </div>
      <div class=\"card-body\">
      <form method=\"post\" action=\"";
            // line 80
            yield PhpMyAdmin\Url::getFromRoute("/preferences/two-factor");
            yield "\">
        ";
            // line 81
            yield PhpMyAdmin\Url::getHiddenInputs();
            yield "
        ";
            // line 82
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["backends"] ?? null));
            foreach ($context['_seq'] as $context["_key"] => $context["backend"]) {
                // line 83
                yield "          <label class=\"d-block\">
            <input type=\"radio\" name=\"2fa_configure\" value=\"";
                // line 84
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($__internal_compile_0 = $context["backend"]) && is_array($__internal_compile_0) || $__internal_compile_0 instanceof ArrayAccess ? ($__internal_compile_0["id"] ?? null) : null), "html", null, true);
                yield "\"";
                // line 85
                yield ((((($__internal_compile_1 = $context["backend"]) && is_array($__internal_compile_1) || $__internal_compile_1 instanceof ArrayAccess ? ($__internal_compile_1["id"] ?? null) : null) == "")) ? (" checked") : (""));
                yield ">
            <strong>";
                // line 86
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($__internal_compile_2 = $context["backend"]) && is_array($__internal_compile_2) || $__internal_compile_2 instanceof ArrayAccess ? ($__internal_compile_2["name"] ?? null) : null), "html", null, true);
                yield "</strong>
            <p>";
                // line 88
                if (((($__internal_compile_3 = $context["backend"]) && is_array($__internal_compile_3) || $__internal_compile_3 instanceof ArrayAccess ? ($__internal_compile_3["id"] ?? null) : null) == "key")) {
                    // line 89
                    yield "<span class=\"text-danger\">
                  ";
                    // line 90
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(_gettext("The FIDO U2F API has been deprecated in favor of the Web Authentication API (WebAuthn)."), "html", null, true);
                    yield "
                </span>
                <br>";
                }
                // line 94
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($__internal_compile_4 = $context["backend"]) && is_array($__internal_compile_4) || $__internal_compile_4 instanceof ArrayAccess ? ($__internal_compile_4["description"] ?? null) : null), "html", null, true);
                yield "
            </p>
          </label>
        ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['backend'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 98
            yield "        <input class=\"btn btn-secondary\" type=\"submit\" value=\"";
yield _gettext("Configure two-factor authentication");
            yield "\">
      </form>
      </div>
    </div>
  </div>
</div>
";
        }
        return; yield '';
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName()
    {
        return "preferences/two_factor/main.twig";
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
        return array (  276 => 98,  266 => 94,  260 => 90,  257 => 89,  255 => 88,  251 => 86,  247 => 85,  244 => 84,  241 => 83,  237 => 82,  233 => 81,  229 => 80,  225 => 78,  218 => 73,  216 => 72,  208 => 66,  203 => 64,  198 => 63,  191 => 59,  186 => 57,  182 => 56,  179 => 55,  177 => 54,  173 => 53,  170 => 52,  163 => 49,  157 => 45,  155 => 44,  148 => 39,  142 => 37,  139 => 36,  136 => 35,  132 => 33,  121 => 31,  117 => 30,  111 => 27,  107 => 26,  104 => 25,  101 => 24,  95 => 22,  89 => 20,  86 => 19,  82 => 17,  71 => 15,  67 => 14,  63 => 12,  57 => 11,  54 => 10,  52 => 9,  45 => 6,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "preferences/two_factor/main.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\preferences\\two_factor\\main.twig");
    }
}
