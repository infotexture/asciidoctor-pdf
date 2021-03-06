# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Asciidoctor Diagram Integration', if: (gem_available? 'asciidoctor-diagram'), &(proc do
  it 'should locate generated diagram when :to_dir is set and imagesdir is not set' do
    require 'asciidoctor-diagram'
    input_file = Pathname.new fixture_file 'diagrams.adoc'
    pdf = to_pdf input_file, safe: :unsafe, attributes: { 'sequence-diagram-name' => 'sequence-diagram-a' }, analyze: :image
    (expect pdf.images).to have_size 1
    (expect Pathname.new output_file 'sequence-diagram-a.png').to exist
    (expect Pathname.new output_file '.asciidoctor/diagram/sequence-diagram-a.png.cache').to exist
    (expect Pathname.new fixture_file 'sequence-diagram-a.png').not_to exist
    (expect Pathname.new fixture_file 'sequence-diagram-a.png.cache').not_to exist
  end

  it 'should generate diagram into imagesdir relative to output dir' do
    require 'asciidoctor-diagram'
    input_file = Pathname.new fixture_file 'diagrams.adoc'
    pdf = to_pdf input_file, safe: :unsafe, attributes: { 'imagesdir' => 'images', 'sequence-diagram-name' => 'sequence-diagram-b' }, analyze: :image
    (expect pdf.images).to have_size 1
    (expect Pathname.new output_file 'images/sequence-diagram-b.png').to exist
    (expect Pathname.new output_file '.asciidoctor/diagram/sequence-diagram-b.png.cache').to exist
    (expect Pathname.new fixture_file 'images/sequence-diagram-b.png').not_to exist
    (expect Pathname.new fixture_file 'images/sequence-diagram-b.png.cache').not_to exist
  end

  it 'should not crash when both Asciidoctor Diagram and pdfmark are active' do
    require 'asciidoctor-diagram'
    input_file = Pathname.new fixture_file 'diagrams.adoc'
    pdfmark_file = Pathname.new output_file 'diagrams.pdfmark'
    pdf = to_pdf input_file, safe: :unsafe, attributes: { 'pdfmark' => '', 'sequence-diagram-name' => 'sequence-diagram-c' }, analyze: :image
    (expect pdf.images).to have_size 1
    (expect pdfmark_file).to exist
  end
end)
