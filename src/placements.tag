<placements>

	<h1>PLACEMENTS</h1>

	<ul>
		<li each={ placements }>
			<p>{ name }</p>
			<ul>
				<li each={ variations }>
					<p>{ name }</p>
					<p>{ weight }</p>
				</li>
			</ul>
		</li>
	</ul>

	<script type="es6">
		'use strict;'
	    this.placements = opts.placements
	</script>

</placements>
