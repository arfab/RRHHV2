namespace RRHH.Models
{
    public class CategoriaJustificacion
    {

        public CategoriaJustificacion()
        {
        }

        public CategoriaJustificacion(int cat_id, string cat_descripcion)
        {
            id = cat_id;
            descripcion = cat_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }


    }
}
