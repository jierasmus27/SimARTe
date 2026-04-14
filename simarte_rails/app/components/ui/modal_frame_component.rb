# frozen_string_literal: true

class Ui::ModalFrameComponent < ViewComponent::Base
  VARIANTS = {
    glass: {
      overlay: "fixed inset-0 z-[100] flex items-center justify-center bg-[#000000]/30",
      panel: "max-w-lg w-full modal-blur glass-panel rounded-[24px] border border-[#acead3]/30 glow-border p-8 relative shadow-[0px_15px_30px_rgba(172,234,211,0.15)]"
    },
    celestial: {
      overlay: "fixed inset-0 z-[100] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4",
      panel: "relative w-full max-w-lg celestial-blur bg-surface-container/60 rounded-xl overflow-hidden border border-primary/20 shadow-[0_0_50px_rgba(172,234,211,0.1)]"
    },
    login: {
      overlay: "fixed inset-0 z-[100] flex items-center justify-center bg-[#000000]/30",
      panel: "glass-panel border border-primary/10 p-10 rounded-sm shadow-[0_40px_100px_rgba(0,0,0,0.5)] relative"
    }
  }.freeze

  def initialize(
    variant: :glass,
    with_overlay: true,
    overlay_extra_class: nil,
    panel_extra_class: nil,
    overlay_html_attributes: {},
    panel_html_attributes: {}
  )
    @variant = variant.to_sym
    @with_overlay = with_overlay
    @overlay_extra_class = overlay_extra_class
    @panel_extra_class = panel_extra_class
    @overlay_html_attributes = overlay_html_attributes
    @panel_html_attributes = panel_html_attributes
  end

  private

  attr_reader :variant, :overlay_extra_class, :panel_extra_class,
    :overlay_html_attributes, :panel_html_attributes

  def overlay_classes
    helpers.class_names(VARIANTS.fetch(variant)[:overlay], overlay_extra_class)
  end

  def panel_classes
    helpers.class_names(VARIANTS.fetch(variant)[:panel], panel_extra_class)
  end

  def overlay_tag_attributes
    merge_tag_attributes({ class: overlay_classes }, overlay_html_attributes)
  end

  def panel_tag_attributes
    merge_tag_attributes({ class: panel_classes }, panel_html_attributes)
  end

  def merge_tag_attributes(base, extras)
    merged = base.deep_symbolize_keys.deep_merge(extras.deep_symbolize_keys)
    merged[:class] = helpers.class_names(merged[:class])
    merged
  end
end
