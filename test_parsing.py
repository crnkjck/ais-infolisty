#!/usr/bin/env python
# -*- coding: utf-8 -*-

import unittest

import AIS_XML2HTML

class ParsingTests(unittest.TestCase):

    def test_parsing_old_course(self):
        filename = 'testin/test-2015-stary.xml'
        webpage = 'http://dai.fmph.uniba.sk/courses/dm2/'

        data = AIS_XML2HTML.extract_infolists(filename, lang='sk', verbose=False,
            webpages={'1-AIN-160_00': webpage})

        self.assertEqual(data[0]['priebezneHodnotenie'], u'hodnoten\xe9 dom\xe1ce \xfalohy, testy v priebehu semestra')
        self.assertEqual(data[0]['zaverecneHodnotenie'], u'sk\xfa\u0161ka')
        self.assertEqual(data[0]['studijnyProgram'], [u'aplikovan\xe1 informatika'])
        self.assertEqual(data[0]['webStranka'], webpage)

    def test_parsing_new_course(self):
        filename = 'testin/test-2015-novy.xml'
        webpage = 'http://python.input.sk/'

        data = AIS_XML2HTML.extract_infolists(filename, lang='sk', verbose=False,
            webpages={'1-AIN-130_13': webpage})

        self.assertEqual(data[0]['podmienkyAbsolvovania'],
            u'<p>Priebežné hodnotenie: domáce úlohy, semestrálny projekt</p>'+
            u'<p>Skúška: záverečný písomný test, praktická skúška pri počítači</p>'+
            u'<p>Orientačná stupnica hodnotenia: A 90%, B 80%, C 70%, D 60%, E 50%</p>')
        self.assertEqual(data[0]['jazyk'], u'slovensk\xfd, anglick\xfd')
        self.assertEqual(data[0]['studijnyProgram'],
            [u'u\u010dite\u013estvo matematiky a informatiky (konverzn\xfd)',
             u'u\u010dite\u013estvo fyziky a informatiky (konverzn\xfd)',
             u'aplikovan\xe1 informatika'])
        self.assertEqual(data[0]['webStranka'], webpage)

    def test_parsing_webpages_csv(self):
        filename = 'testin/webpages.d/dai.csv'

        data = AIS_XML2HTML.load_webpages(filename, {})

        self.assertEqual(len(data), 2)
        self.assertEqual(data['1-AIN-130_13'],'http://python.input.sk/')
        self.assertEqual(data['1-AIN-470_15'],'http://ii.fmph.uniba.sk/cl/view/courses/1-AIN-470-svp/?lang=sk')

if __name__ == '__main__':
    unittest.main()

