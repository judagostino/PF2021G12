import { Injectable } from '@angular/core';
import * as ExcelJS from 'exceljs';
import * as fs from 'file-saver';


@Injectable({
  providedIn: 'root'
})
export class SqvExportExcelService {

  title: string;
  titleWorksheet = 'sheet1';
  headerBgColor = '000000';
  headerFontColor = 'FFFFFF';
  headerTotalizer: {text: string, concept: string}[] = [];

  constructor() { }


  /**
   * Metodo encargado de generar y organizar la info para exportar.
   * @param responseData respuesta de la peticion que armo la grilla.
   */
  public exportToExcel(responseData: any): void {
    // const workbook = new ExcelJS.Workbook();
    // const worksheet = workbook.addWorksheet(translations[this.titleWorksheet]);

    // this.initTitle(worksheet, translations[this.title]);
    // this.setTotalizer(worksheet, responseData, translations as string[]);
    // this.setColumns(worksheet, translations as string[]);
    // this.setData(worksheet, responseData);
    // this.createExcel(workbook, translations[this.title]);
  }


  /**
   * Metodo encargado de definir el estilo y ubicacion del titulo.
   * @param worksheet hoja de trabajo a editar.
   * @param title titulo a poner.
   */
  private initTitle(worksheet: ExcelJS.Worksheet, title: string): void {
    // Add Row and formatting
    const titleRow = worksheet.getCell('A1');
    titleRow.value = title;
    titleRow.font = {
      name: 'Calibri',
      size: 16,
      bold: true
    };
    titleRow.alignment = {
      horizontal: 'left'
    };
  }



  /**
   * Metodo encargado de definir el estilo, ancho y texto de cada una de las columnas.
   * @param worksheet hoja de trabajo a editar
   * @param columnsName  array de las traducciones de las columnas.
   */
  private setColumns(worksheet: ExcelJS.Worksheet, columnsName: string[]): void {
    const aux = [];
    // this.columns.forEach((column, index) => {
    //   aux.push(columnsName[column.headerName]);
    //   worksheet.getColumn(index + 1).width = 33;
    // });

    worksheet.addRow([]);

    // Adding Header Row
    const headerRow = worksheet.addRow(aux);
    headerRow.eachCell((cell) => {
      cell.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: this.headerBgColor },
        bgColor: { argb: '' },
      };
      cell.font = {
        bold: true,
        color: { argb: this.headerFontColor },
        size: 12,
      };
      cell.alignment = {
        vertical: 'middle',
        horizontal: 'center'
      };
    });
  }


  /**
   * Metodo encargado de definir cada uno de los renglones de la grilla,
   * tomando el tipo definido y haciendo la transformacion correspondiente.
   * @param worksheet hoja de trabajo a utilizar.
   * @param res respuesta del metodo que armo la grilla, puede incluir totalizadores o no.
   */
  private setData(worksheet: ExcelJS.Worksheet): void {
    // res.data.forEach(row => {
    //   const aux = [];

    //   this.columns.forEach(column => {
    //     switch (column.type)  {
    //       case (GridColumType.NUMBER): {
    //         aux.push(row[column.field] ? row[column.field] : 0);
    //         break;
    //       }
    //       case (GridColumType.DATE): {
    //         aux.push(row[column.field] ? this.pqvLocalDate.transform(row[column.field], 'shortDate') : null);
    //         break;
    //       }
    //       case (GridColumType.DATETIME): {
    //         aux.push(row[column.field] ? this.pqvLocalDate.transform(row[column.field], 'short') : null);
    //         break;
    //       }
    //       case (GridColumType.CHECKBOX): {
    //         aux.push(row[column.field] ? row[column.field] : false);
    //         break;
    //       }
    //       default: {
    //         aux.push(row[column.field] ? row[column.field] : null);
    //         break;
    //       }
    //     }
    //   });

    //   worksheet.addRow(aux);
    // });
  }


  /**
   * Metodo encargado de generar y guardar el archivo final, con toda la informacion definida.
   * @param workbook libro de trabajo a guardar.
   * @param title titulo del libro de trabajo.
   */
  private createExcel(workbook: ExcelJS.Workbook, title: string): void {
     // Generate & Save Excel File
     workbook.xlsx.writeBuffer().then((data) => {
      const blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
      fs.saveAs(blob, title + '.xlsx');
    });
  }
}
