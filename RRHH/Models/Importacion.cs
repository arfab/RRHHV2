namespace RRHH.Models
{
    public class Importacion
    {
        //public Importacion()
        //{
        //}

        //public Importacion(int imp_id, string imp_tipo,  string imp_nombre_archivo)
        //{
        //    id = imp_id;
        //    tipo = imp_tipo;
        //    nombre_archivo = imp_nombre_archivo;
        //}

        public int id { get; set; }

        public string tipo { get; set; }

        public string nombre_archivo { get; set; }

        public DateTime fecha { get; set; }

        public int cantidad { get; set; }

        public int errores { get; set; }

    }
}

