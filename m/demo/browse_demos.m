a = dircrawler_demoindexbuilder();
a = a.go();
lo = log_html();
lo.title = 'IRootLab Demo Menu';
lo.html = a.html;
lo.open_in_browser();