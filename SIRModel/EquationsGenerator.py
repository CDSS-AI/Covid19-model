import re

from pylatex import (Alignat, Center, Document, LargeText, LineBreak, Math,
                     MediumText, PageStyle, Section, Subsection)
from pylatex.utils import NoEscape, bold, italic


class EquationsGenerator:
    def __init__(self, equations):
        geometry_options = {
            "head": "2.5cm",
            "left": "3cm",
            "right": "3cm",
            "bottom": "2.5cm"
            }
        doc = Document(geometry_options = geometry_options, inputenc = 'utf8')
        self.doc = doc
        equations = self.Read(equations)
        self.Create(equations)
        self.doc.generate_pdf(filepath = 'Equations', clean_tex = False, compiler = 'pdflatex')

    def Read(self, equations):
        eqs = []
        for key in equations:
            value = ' '.join([line.strip() for line in equations.get(key).strip().splitlines()])
            equation = key + " &= " + value
            eqs.append(equation)
        return eqs

    def Create(self, equations):
        with self.doc.create(Center()) as Centered:
            with Centered.create(Section(title='', numbering='')) as Title:
                Title.append(LargeText(bold('Generalized S-I-R model')))

        with self.doc.create(Section(title='Equations', numbering='1.')) as Intro:
            Intro.append(MediumText(('These are the equations for the model:')))

        for eq in equations:
            with self.doc.create(Alignat(numbering = False, escape = False)) as math_eq:
                math_eq.append(eq)
