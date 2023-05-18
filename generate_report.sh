(cd report && \
platex report.tex && \
pbibtex report && \
platex report.tex && \
platex report.tex && \
dvipdfmx report.dvi)
