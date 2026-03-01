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

/* database/events/index.twig */
class __TwigTemplate_9940c6bc4e967d5b9dfae0531dc872b8 extends Template
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
        yield PhpMyAdmin\Html\Generator::getIcon("b_events", _gettext("Events"));
        yield "
    ";
        // line 4
        yield PhpMyAdmin\Html\MySQLDocumentation::show("EVENTS");
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
    </div>";
        }
        // line 26
        yield "
    <div";
        // line 27
        yield (( !Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) ? (" class=\"ms-auto\"") : (""));
        yield ">
      <a class=\"ajax add_anchor btn btn-primary";
        // line 28
        yield (( !($context["has_privilege"] ?? null)) ? (" disabled") : (""));
        yield "\" href=\"";
        yield PhpMyAdmin\Url::getFromRoute("/database/events", ["db" => ($context["db"] ?? null), "add_item" => true]);
        yield "\" role=\"button\"";
        yield (( !($context["has_privilege"] ?? null)) ? (" tabindex=\"-1\" aria-disabled=\"true\"") : (""));
        yield ">
        ";
        // line 29
        yield PhpMyAdmin\Html\Generator::getIcon("b_event_add", _gettext("Create new event"));
        yield "
      </a>
    </div>
  </div>

  <form id=\"rteListForm\" class=\"ajax\" action=\"";
        // line 34
        yield PhpMyAdmin\Url::getFromRoute("/database/events");
        yield "\">
    ";
        // line 35
        yield PhpMyAdmin\Url::getHiddenInputs(($context["db"] ?? null));
        yield "

    <div id=\"nothing2display\"";
        // line 37
        yield (( !Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) ? (" class=\"hide\"") : (""));
        yield ">
      ";
        // line 38
        yield $this->env->getFilter('notice')->getCallable()(_gettext("There are no events to display."));
        yield "
    </div>

    <table id=\"eventsTable\" class=\"table table-striped table-hover";
        // line 41
        yield ((Twig\Extension\CoreExtension::testEmpty(($context["items"] ?? null))) ? (" hide") : (""));
        yield " w-auto data\">
      <thead>
      <tr>
        <th></th>
        <th>";
yield _gettext("Name");
        // line 45
        yield "</th>
        <th>";
yield _gettext("Status");
        // line 46
        yield "</th>
        <th>";
yield _gettext("Type");
        // line 47
        yield "</th>
        <th colspan=\"3\"></th>
      </tr>
      </thead>
      <tbody>
      <tr class=\"hide\">";
        // line 52
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(range(0, 6));
        foreach ($context['_seq'] as $context["_key"] => $context["i"]) {
            yield "<td></td>";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['i'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        yield "</tr>

      ";
        // line 54
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["items"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["event"]) {
            // line 55
            yield "        <tr";
            yield ((($context["is_ajax"] ?? null)) ? (" class=\"ajaxInsert hide\"") : (""));
            yield ">
          <td>
            <input type=\"checkbox\" class=\"checkall\" name=\"item_name[]\" value=\"";
            // line 57
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["event"], "name", [], "any", false, false, false, 57), "html", null, true);
            yield "\">
          </td>
          <td>
            <span class=\"drop_sql hide\">";
            // line 60
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Twig\Extension\CoreExtension::sprintf("DROP EVENT IF EXISTS %s", PhpMyAdmin\Util::backquote(CoreExtension::getAttribute($this->env, $this->source, $context["event"], "name", [], "any", false, false, false, 60))), "html", null, true);
            yield "</span>
            <strong>";
            // line 61
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["event"], "name", [], "any", false, false, false, 61), "html", null, true);
            yield "</strong>
          </td>
          <td>
            ";
            // line 64
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["event"], "status", [], "any", false, false, false, 64), "html", null, true);
            yield "
          </td>
          <td>
            ";
            // line 67
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(CoreExtension::getAttribute($this->env, $this->source, $context["event"], "type", [], "any", false, false, false, 67), "html", null, true);
            yield "
          </td>
          <td>
            ";
            // line 70
            if (($context["has_privilege"] ?? null)) {
                // line 71
                yield "              <a class=\"ajax edit_anchor\" href=\"";
                yield PhpMyAdmin\Url::getFromRoute("/database/events", ["db" =>                 // line 72
($context["db"] ?? null), "edit_item" => true, "item_name" => CoreExtension::getAttribute($this->env, $this->source,                 // line 74
$context["event"], "name", [], "any", false, false, false, 74)]);
                // line 75
                yield "\">
                ";
                // line 76
                yield PhpMyAdmin\Html\Generator::getIcon("b_edit", _gettext("Edit"));
                yield "
              </a>
            ";
            } else {
                // line 79
                yield "              ";
                yield PhpMyAdmin\Html\Generator::getIcon("bd_edit", _gettext("Edit"));
                yield "
            ";
            }
            // line 81
            yield "          </td>
          <td>
            <a class=\"ajax export_anchor\" href=\"";
            // line 83
            yield PhpMyAdmin\Url::getFromRoute("/database/events", ["db" =>             // line 84
($context["db"] ?? null), "export_item" => true, "item_name" => CoreExtension::getAttribute($this->env, $this->source,             // line 86
$context["event"], "name", [], "any", false, false, false, 86)]);
            // line 87
            yield "\">
              ";
            // line 88
            yield PhpMyAdmin\Html\Generator::getIcon("b_export", _gettext("Export"));
            yield "
            </a>
          </td>
          <td>
            ";
            // line 92
            if (($context["has_privilege"] ?? null)) {
                // line 93
                yield "              ";
                yield PhpMyAdmin\Html\Generator::linkOrButton(PhpMyAdmin\Url::getFromRoute("/sql"), ["db" =>                 // line 96
($context["db"] ?? null), "sql_query" => Twig\Extension\CoreExtension::sprintf("DROP EVENT IF EXISTS %s", PhpMyAdmin\Util::backquote(CoreExtension::getAttribute($this->env, $this->source,                 // line 97
$context["event"], "name", [], "any", false, false, false, 97))), "goto" => PhpMyAdmin\Url::getFromRoute("/database/events", ["db" =>                 // line 98
($context["db"] ?? null)])], PhpMyAdmin\Html\Generator::getIcon("b_drop", _gettext("Drop")), ["class" => "ajax drop_anchor"]);
                // line 102
                yield "
            ";
            } else {
                // line 104
                yield "              ";
                yield PhpMyAdmin\Html\Generator::getIcon("bd_drop", _gettext("Drop"));
                yield "
            ";
            }
            // line 106
            yield "          </td>
        </tr>
      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['event'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 109
        yield "      </tbody>
    </table>
  </form>

  <div class=\"card mt-3\">
    <div class=\"card-header\">";
yield _gettext("Event scheduler status");
        // line 114
        yield "</div>
    <div class=\"card-body\">
      <div class=\"wrap\">
        <div class=\"wrapper toggleAjax hide\">
          <div class=\"toggleButton\">
            <div title=\"";
yield _gettext("Click to toggle");
        // line 119
        yield "\" class=\"toggle-container ";
        yield ((($context["scheduler_state"] ?? null)) ? ("on") : ("off"));
        yield "\">
              <img src=\"";
        // line 120
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['PhpMyAdmin\Twig\AssetExtension']->getImagePath((("toggle-" . ($context["text_dir"] ?? null)) . ".png")), "html", null, true);
        yield "\">
              <table>
                <tbody>
                <tr>
                  <td class=\"toggleOn\">
                  <span class=\"hide\">";
        // line 126
        yield PhpMyAdmin\Url::getFromRoute("/sql", ["db" =>         // line 127
($context["db"] ?? null), "goto" => PhpMyAdmin\Url::getFromRoute("/database/events", ["db" =>         // line 128
($context["db"] ?? null)]), "sql_query" => "SET GLOBAL event_scheduler=\"ON\""]);
        // line 131
        yield "</span>
                    <div>";
yield _gettext("ON");
        // line 132
        yield "</div>
                  </td>
                  <td><div>&nbsp;</div></td>
                  <td class=\"toggleOff\">
                  <span class=\"hide\">";
        // line 137
        yield PhpMyAdmin\Url::getFromRoute("/sql", ["db" =>         // line 138
($context["db"] ?? null), "goto" => PhpMyAdmin\Url::getFromRoute("/database/events", ["db" =>         // line 139
($context["db"] ?? null)]), "sql_query" => "SET GLOBAL event_scheduler=\"OFF\""]);
        // line 142
        yield "</span>
                    <div>";
yield _gettext("OFF");
        // line 143
        yield "</div>
                  </td>
                </tr>
                </tbody>
              </table>
              <span class=\"hide callback\">Functions.slidingMessage(data.sql_query);</span>
              <span class=\"hide text_direction\">";
        // line 149
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["text_dir"] ?? null), "html", null, true);
        yield "</span>
            </div>
          </div>
        </div>
      </div>
    </div>
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
        return "database/events/index.twig";
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
        return array (  327 => 149,  319 => 143,  315 => 142,  313 => 139,  312 => 138,  311 => 137,  305 => 132,  301 => 131,  299 => 128,  298 => 127,  297 => 126,  289 => 120,  284 => 119,  276 => 114,  268 => 109,  260 => 106,  254 => 104,  250 => 102,  248 => 98,  247 => 97,  246 => 96,  244 => 93,  242 => 92,  235 => 88,  232 => 87,  230 => 86,  229 => 84,  228 => 83,  224 => 81,  218 => 79,  212 => 76,  209 => 75,  207 => 74,  206 => 72,  204 => 71,  202 => 70,  196 => 67,  190 => 64,  184 => 61,  180 => 60,  174 => 57,  168 => 55,  164 => 54,  152 => 52,  145 => 47,  141 => 46,  137 => 45,  129 => 41,  123 => 38,  119 => 37,  114 => 35,  110 => 34,  102 => 29,  94 => 28,  90 => 27,  87 => 26,  80 => 21,  77 => 20,  71 => 18,  68 => 17,  62 => 14,  54 => 9,  52 => 8,  46 => 4,  42 => 3,  38 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "database/events/index.twig", "C:\\Users\\Levi\\Desktop\\Szakmai\\dualis\\13.d\\Git repok\\Messengeres-vizsgaremek\\xampp_server\\phpMyAdmin\\templates\\database\\events\\index.twig");
    }
}
